import 'package:flutter/cupertino.dart';
import '../../../../models/shooting/result.dart';
import 'ShotView/shot_view.dart';

class ResultCard extends StatelessWidget {
  final Result result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            ShotView(result: result, size: 200),
            Column(
              children: [
                Text(result.disciplineClass),
                Text(result.formatTime()),
                Row(
                  spacing: 10,
                  children: [
                    Text(result.calcNonTenthValue().toString()),
                    Text(result.value.toString()),
                  ],
                ),
              ],
            )
          ],
        ));
  }
}
