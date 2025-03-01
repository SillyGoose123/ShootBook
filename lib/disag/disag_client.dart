import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shootbook/disag/disag_utils.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/models/result.dart';
import "package:shootbook/localizations/app_localizations.dart";

String tokenKey = "disagKey";
FlutterSecureStorage storage = FlutterSecureStorage();

class TokenException implements Exception {
  TokenException(String s);
}

class DisagClient {
  static DisagClient? instance;
  final String _token;
  final AppLocalizations _locale;

  DisagClient._create(this._token, this._locale);

  static Future<DisagClient> getInstance(AppLocalizations locale) async {
    if (instance == null) {
      //load token from store
      final token = await storage.read(key: tokenKey);

      if (token == null) {
        throw TokenException("No token found.");
      }

      if (!await _checkToken(token)) {
        throw TokenException(
            "Stored token is invalid user need to login first");
      }

      instance = DisagClient._create(token, locale);
    }

    return instance!;
  }

  static Future<DisagClient> login(
      String email, String password, AppLocalizations locale) async {
    if (instance != null) {
      throw Exception(
          "ApiClient already instantiated. Logout before you login.");
    }

    String token = await _getToken(email, password);

    //write to store
    await storage.write(key: tokenKey, value: token);

    instance = DisagClient._create(token, locale);

    return instance!;
  }

  static void logout() async {
    instance = null;
    await storage.delete(key: tokenKey);
  }

  static Future<bool> _checkToken(String token) async {
    var res = await http
        .get(Uri.parse("https://shotsapp.disag.de/api/user/profile"), headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    if (res.statusCode != 200) {
      logout();
    }

    return res.statusCode == 200;
  }

  static Future<String> _getToken(String email, String password) async {
    var req = http.MultipartRequest(
        "POST", Uri.parse("https://shotsapp.disag.de/api/token"));

    req.fields["email"] = email;
    req.fields["password"] = password;
    req.fields["device_name"] = "Shoot Book Mobile";

    var res = await req.send();

    if (res.statusCode != 200) {
      throw Exception("Failed fetching token. Maybe the credentials are wrong");
    }

    return res.stream.bytesToString();
  }

  Future<http.StreamedResponse> makeRequest(
      http.BaseRequest req, String errorMsg) async {
    req.headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer $_token",
    });

    var res = await req.send();

    if (res.statusCode != 200) {
      if (await _checkToken(_token)) {
        throw Exception("Token expired.");
      }

      throw Exception(errorMsg);
    }

    return res;
  }

  Future<http.StreamedResponse> _qrRequest(
      String qrCodeLink, bool isPreview) async {
    var req = http.MultipartRequest(
        "POST", Uri.parse("https://shotsapp.disag.de/api/results"));

    req.fields["data"] = qrCodeLink;

    return await makeRequest(req, "Failed fetching qr code data");
  }

  Future<Result> getQrCodeDataPreview(String qrCodeLink) async {
    var res = await _qrRequest(qrCodeLink, true);
    var json = jsonDecode(await res.stream.bytesToString());
    return Result.fromDisag(json, _locale);
  }

  Future<List<dynamic>> _makeResultReq() async {
    var req =
        http.Request("GET", Uri.parse("https://shotsapp.disag.de/api/results"));
    var res = await makeRequest(req, "Failed fetching your results.");
    var body = await res.stream.bytesToString();

    return jsonDecode(body)["data"];
  }

  Future<void> acceptResult(String qrCodeLink) async {
    Map<String, dynamic> res =
        jsonDecode((await _qrRequest(qrCodeLink, false)).toString());
    List<dynamic> results = await _makeResultReq();

    if (results.contains({"id": res["id"]})) {
      throw Exception("Result already added.");
    }

    ModelSaver saver = await ModelSaver.getInstance();
    saver.save(Result.fromDisag(res, _locale));
  }

  Future<List<Result>> getAllResults() async {
    var res = await _makeResultReq();
    return gatherAllResults(res, _locale);
  }

  Future<void> deleteResult(String id) async {
    var req = http.Request(
        "DELETE", Uri.parse("https://shotsapp.disag.de/api/results/$id}"));
    await makeRequest(req, "Couldn't delete result (id: $id).");
  }
}
