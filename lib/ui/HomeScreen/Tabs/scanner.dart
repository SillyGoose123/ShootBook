import 'package:flutter/material.dart';
import 'package:shootbook/disag/disag_client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      _client = await ApiClient.getInstance(AppLocalizations.of(context)!);
    } catch(e) {
      _login = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _tryLogin();
    
    if(_client == null && _login) {
      return DisagLogin(onLogin: (ApiClient client) => _client = client);
    }
    
    if(_client == null) {
      return CircularProgressIndicator();
    }
    
    return Text("Scanner");
  }

}