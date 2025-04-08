import 'package:flutter/cupertino.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/shot_view.dart';
import '../../../../models/shooting/result.dart';

class ResultCard extends StatelessWidget {
  final Result result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(5), child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        SizedBox(height: 100, width: 100, child: ShotView(result: result)),
        Column(
          children: [
            Text(result.type.toText()),
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
