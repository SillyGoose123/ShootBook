import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/disag/disag_client.dart';
import 'package:shootbook/disag/disag_utils.dart';
import "package:shootbook/localizations/app_localizations.dart";
import 'package:shootbook/ui/common/utils.dart';

class DisagLogin extends StatefulWidget {
  const DisagLogin({super.key, required this.onLogin});

  final void Function(DisagClient client) onLogin;

  @override
  State<StatefulWidget> createState() => _DisagLoginState();
}

class _DisagLoginState extends State<DisagLogin> {
  late AppLocalizations locale;
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController pswController = TextEditingController(text: "");
  late final GlobalKey<FormState> formKey;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context)!;

    if (loading) return Center(child: CircularProgressIndicator());

    return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Flexible(
                  child: Text(locale.disagLoginExplanation,
                      textAlign: TextAlign.center)),
              TextFormField(
                  controller: emailController,
                  validator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofillHints: [AutofillHints.username],
                  enableSuggestions: true,
                  onChanged: (value) => setState(() {
                        /* Update Elevated button */
                      }),
                  decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email),
                      labelText: "Email")),
              TextField(
                  controller: pswController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofillHints: [AutofillHints.password],
                  onChanged: (value) => setState(() {
                        /* Update Elevated button */
                      }),
                  decoration: InputDecoration(
                      icon: Icon(CupertinoIcons.padlock),
                      labelText: locale.password)),
              ElevatedButton(
                  onPressed: isInputValid() ? onPress : null,
                  child: Text(locale.loginDisag))
            ]));
  }

  String? validateEmail(String? value) {
    return (value == null || value.isEmpty || checkEmail(value))
        ? null
        : locale.invalidEmail;
  }

  bool isInputValid() {
    return emailController.text.isNotEmpty &&
        pswController.text.isNotEmpty &&
        formKey.currentState != null &&
        formKey.currentState!.validate();
  }

  void onPress() {
    DisagClient.login(emailController.text, pswController.text, locale)
        .then((value) => widget.onLogin(value))
        .catchError((e) {
          setState(() {
            loading = false;
          });

          if(mounted) {
            showSnackBarError(locale.loginFailed, context);
          }
    });
  }
}
