import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shootbook/disag/disag_utils.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/models/result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ApiClient {
  static ApiClient? instance;
  final storage = FlutterSecureStorage();
  final String tokenKey = "disagKey";
  final String _token;
  final AppLocalizations _locale;

  ApiClient._create(this._token, this._locale);

  Future<ApiClient> getInstance(AppLocalizations locale) async {
    if(instance == null) {
      //load token from store
      final token = await storage.read(key: tokenKey);

      if(token == null) {
        throw Exception("No token found.");
      }

      if(!await _checkToken(token)) {
        throw Exception("Stored token is invalid user need to login first");
      }

      instance = ApiClient._create(token, locale);
    }

    return instance!;
  }

  Future<ApiClient> login(String email, String password, AppLocalizations locale) async {
    if(instance != null) throw Exception("ApiClient already instantiated. Logout before you login.");

    String token = await _getToken(email, password);

    //write to store
    await storage.write(key: tokenKey, value: token);

    instance = ApiClient._create(token, locale);

    return instance!;
  }

  void logout() async {
    instance = null;
    await storage.delete(key: tokenKey);
  }

   Future<bool> _checkToken(String token) async {
    var res = await http.get(Uri.parse("https://shotsapp.disag.de/api/user/profile"), headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if(res.statusCode != 200) {
      logout();
    }

    return res.statusCode == 200;
  }

  Future<String> _getToken(String email, String password) async {
    var req =
    http.MultipartRequest("POST", Uri.parse("https://shosapp.disag.de/api/results/preview"));

    req.fields["email"] = email;
    req.fields["password"] = password;
    req.fields["device_name"] = "Shoot Book Mobile";

    var res = await req.send();

    if(res.statusCode != 200) {
      throw Exception("Failed fetching token. Maybe the credentials are wrong");
    }

    return res.stream.toString();
  }

  Future<http.StreamedResponse> makeRequest(http.BaseRequest req, String errorMsg) async {
    req.headers.addAll({
      HttpHeaders.authorizationHeader: _token,
    });

    var res = await req.send();

    if(res.statusCode != 200) {
      if(await _checkToken(_token)) {
        throw Exception("Token expired.");
      }

      throw Exception(errorMsg);
    }

    return res;
  }

  Future<http.StreamedResponse> _qrRequest(String qrCodeLink, bool isPreview) async {
    var req =
    http.MultipartRequest("POST", Uri.parse("https://shosapp.disag.de/api/results${isPreview ? "/preview" : ""}"));
    req.fields["data"] = qrCodeLink;

    return await makeRequest(req, "Failed fetching qr code data");
  }

  Future<Result> getQrCodeDataPreview(String qrCodeLink) async {
    var res = _qrRequest(qrCodeLink, true);
    return Result.fromDisag(jsonDecode(res.toString()), _locale);
  }

  Future<List<Map<String, dynamic>>> _makeResultReq() async {
    var req = http.Request("GET", Uri.parse("https://shotsapp.disag.de/api/results"));
    var res = makeRequest(req, "Failed fetching your results.");
    return jsonDecode(res.toString()).data;
  }

  Future<void> acceptResult(String qrCodeLink) async {
    Map<String, dynamic> res = jsonDecode((await _qrRequest(qrCodeLink, false)).toString());
    List<Map<String, dynamic>> results = await _makeResultReq();

    if(results.contains({"id": res["id"]})) {
      throw Exception("Result already added.");
    }

    ModelSaver saver = await ModelSaver.getInstance();
    saver.save(Result.fromDisag(res, _locale));
  }

  Future<List<Result>> getAllResults() async {
    var res = await _makeResultReq();
    return gatherAllResults(res.toString(), _locale);
  }

  Future<void> deleteResult(String id) async {
    var req = http.Request("DELETE", Uri.parse("https://shotsapp.disag.de/api/results/$id}"));
    await makeRequest(req, "Couldn't delete result (id: $id).");
  }

}