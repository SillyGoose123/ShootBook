import 'package:flutter/cupertino.dart';

import '../../../../models/result.dart';

class ResultCard extends StatelessWidget {
  final Result result;
  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("PREVIEW"),
        Row(children: [
          Text(result.type.toString()),
          Text(result.timestamp.toString()),
          Text(result.value.toString()),
        ],)
      ],
    );
  }

}