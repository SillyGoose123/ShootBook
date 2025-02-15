import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shootbook/disag/disag_client.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/ui/common/disag_login.dart';
import 'package:shootbook/ui/common/utils.dart';

import '../../../models/result.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  AppLocalizations? locale;

  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context)!;

    return Column(children: [
      ElevatedButton(onPressed: () => _disagImport(context), child: Row(children: [Icon(Icons.download), Text(locale!.importDisagResults)],))
    ]);
  }

  void _disagImport(BuildContext context) {
    try {
      _disagClientImport();
    } catch(e)  {
      Navigator.of(context).push(showPage(DisagLogin(onLogin: (ApiClient client) => _disagClientImport()), context));
    }
  }

  Future<void> _disagClientImport() async {
    ApiClient client = await ApiClient.getInstance(locale!);
    List<Result> res = await client.getAllResults();

    ModelSaver saver = await ModelSaver.getInstance();
    saver.saveAll(res);
  }
}