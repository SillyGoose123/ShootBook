import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/disag/disag_client.dart';
import "package:shootbook/localisation/app_localizations.dart";
import 'package:shootbook/ui/common/disag_login.dart';

class Scanner extends StatefulWidget {
  final CupertinoTabController tabController;
  final int myIndex;

  const Scanner({super.key, required this.tabController, required this.myIndex});

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool _login = false;
  ApiClient? _client;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tryLogin();
  }

  @override
  void initState() {
    super.initState();


    //detect when tab is open again
    widget.tabController.addListener(()  {
      if(widget.tabController.index == widget.myIndex) {
        _tryLogin();
      }
    });
  }

  Future<void> _tryLogin() async{
    setState(() {
      _login = false;
    });

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