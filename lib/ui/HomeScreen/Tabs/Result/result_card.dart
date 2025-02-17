import 'package:flutter/cupertino.dart';
import 'package:shootbook/models/result_type.dart';

import '../../../../models/result.dart';

class ResultCard extends StatelessWidget {
  final Result result;
  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text("PREVIEW"),
        Column(children: [
          Text(result.type.toText()),
          Text(result.formatTime()),
          Row(spacing: 10, children: [
            Text(result.calcNonTenthValue().toString()),
            Text(result.value.toString())
          ],)
         ,
        ],)
      ],
    );
  }

}