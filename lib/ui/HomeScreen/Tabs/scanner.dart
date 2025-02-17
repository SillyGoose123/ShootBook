import 'package:flutter/material.dart';
import 'package:shootbook/disag/disag_client.dart';
import "package:shootbook/localisation/app_localizations.dart";
import 'package:shootbook/ui/common/disag_login.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool _login = false;
  ApiClient? _client;

  Future<void> _tryLogin() async{
    try {
      var tempClient = await ApiClient.getInstance(AppLocalizations.of(context)!);
      setState(() {
        _client = tempClient;
      });
    } catch(e) {
      setState(() {
        _client = null;
        _login = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    _tryLogin();
    
    if(_client == null && _login) {
      return DisagLogin(onLogin: (ApiClient client) => setState(() {
        _client = client;
      }));
    }

    if(_client == null) {
      return Center(child: CircularProgressIndicator());
    }
    
    return Text("Scanner");
  }

}