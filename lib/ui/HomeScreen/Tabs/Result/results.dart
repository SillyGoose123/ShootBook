import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/models/result.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/result_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<StatefulWidget> createState() => _ResultState();
}

//TODO: FILTER FEATURE
class _ResultState extends State<Results> {
  List<Result>? results;

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    if (results == null) {
      return CircularProgressIndicator();
    }

    if (results!.isEmpty) {
      return Column(
          children: [Icon(CupertinoIcons.nosign), Text(locale.noResults)]);
    }

    return ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ResultCard(result: results![index]));
  }

  Future<void> _loadResults() async {
    ModelSaver saver = await ModelSaver.getInstance();
    results = await saver.loadAll();
  }
}
