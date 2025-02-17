import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import "package:shootbook/localisation/app_localizations.dart";
import 'package:shootbook/disag/disag_client.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/ui/common/disag_login.dart';
import 'package:shootbook/ui/common/utils.dart';

import '../../../models/result.dart';

//disag import page mit der man auswählen kann was man will
class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  AppLocalizations? locale;
  bool login = false;
  BuildContext? dialogContext;

  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context)!;

    if (login) {
      return PopScope(
          canPop: false,
          onPopInvokedWithResult: onPop,
          child: DisagLogin(onLogin: (ApiClient client) {
            setState(() {
              login = false;
            });
          }));
    }

    return Column(spacing: 10, children: [
      ElevatedButton.icon(
          onPressed: dialogContext == null ? _disagClientImport : null,
          icon: Icon(Icons.download),
          label: Text(locale!.importDisagResults)),
      ElevatedButton.icon(
          onPressed: () => ApiClient.logout(),
          icon: Icon(Icons.logout),
          label: Text(locale!.logout)),
    ]);
  }

  void onPop(bool close, test) {
    setState(() {
      login = false;
    });
  }

  Future<void> _disagClientImport() async {
    try {
      ApiClient client = await ApiClient.getInstance(locale!);
      showLoadingDialog();
      List<Result> res = await client.getAllResults();

      ModelSaver saver = await ModelSaver.getInstance();
      if(dialogContext != null && dialogContext!.mounted) {
        await saver.saveAll(res, dialogContext!);
      }
    } on TokenException catch (e) {
      setState(() {
        login = true;
      });
    } catch (e) {
      print(e);
      if (context.mounted) {
        showSnackBarError(locale!.importFailed, context);
      }
    }
    if (dialogContext!.mounted) {
      Navigator.pop(dialogContext!);
      setState(() {
        dialogContext = null;
      });
    }
  }

  void showLoadingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return PopScope(
              canPop: false,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                      child: Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${locale!.importDisagResults}..."),
                          Center(child: CircularProgressIndicator())
                        ],
                      ))));
        });
    setState(() {});
  }
}
