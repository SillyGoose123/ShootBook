import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/models/result.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/result_card.dart';
import "package:shootbook/localizations/app_localizations.dart";

class Results extends StatefulWidget {
  final CupertinoTabController tabController;
  final int myIndex;

  const Results({super.key, required this.tabController, required this.myIndex});

  @override
  State<StatefulWidget> createState() => _ResultState();
}

//TODO: FILTER FEATURE
class _ResultState extends State<Results> {
  List<Result>? results;

  @override
  void initState() {
    super.initState();

    _loadResults();

    //detect when tab is open again
    widget.tabController.addListener(()  {
      if(widget.tabController.index == widget.myIndex) {
        _loadResults();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    if (results == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (results!.isEmpty) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(
              CupertinoIcons.nosign,
              size: 150.0,
            ),
            Text(locale.noResults, textAlign: TextAlign.center,)
          ]);
    }

    return RefreshIndicator(
        onRefresh: _loadResults,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: results!.length,
            itemBuilder: (BuildContext context, int index) =>
                ResultCard(result: results![index])));
  }

  Future<void> _loadResults() async {
    ModelSaver saver = await ModelSaver.getInstance();
    var temp = await saver.load(true);

    setState(() {
      results = temp;
    });
  }
}
