import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/disag/disag_client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DisagLogin extends StatefulWidget {
  const DisagLogin({super.key, required this.onLogin});

  final Function(ApiClient client) onLogin;

  @override
  State<StatefulWidget> createState() => _DisagLoginState();
}

//TODO: check if disag app detects if email or psw wrong
//TODO: Handle Login Error with toast or snack bar or making fields red
class _DisagLoginState extends State<StatefulWidget> {
  late AppLocalizations locale;
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController pswController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context)!;

    return Row(children: [
      Text(locale.disagLoginExplanation),
      TextField(
          controller: emailController,
          decoration: InputDecoration(
              icon: Icon(Icons.alternate_email), label: const Text("Email"))),
      TextField(
          controller: pswController,
          decoration: InputDecoration(
              icon: Icon(CupertinoIcons.padlock),
              label: Text(locale.password))),
      TextButton(
          onPressed: onPress,
          child: Text(locale.loginDisag))
    ]);
  }

  void onPress() {
    try {
      ApiClient.login(emailController.text, pswController.text, locale).then((value) => widget.onLogin);
    } catch(e) {
      pswController.clear();
    }
  }
}
