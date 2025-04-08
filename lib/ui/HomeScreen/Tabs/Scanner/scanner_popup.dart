import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/shot_view.dart';
import '../../../../models/shooting/result.dart';

class ScannerBottomSheet extends StatefulWidget {
  final Result result;
  final void Function() onSave;

  const ScannerBottomSheet(
      {super.key, required this.result, required this.onSave});

  @override
  State<ScannerBottomSheet> createState() => _ScannerBottomSheetState();
}

class _ScannerBottomSheetState extends State<ScannerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      key: ValueKey(widget.result),
      initialChildSize: 0.42,
      minChildSize: 0.07,
      maxChildSize: 0.42,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            color: Colors.black26,
            child: ListView(
              controller: scrollController,
              children: [
                Column(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const SizedBox(
                      width: 40,
                      height: 5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${widget.result.type.toText()} ${widget.result.calcNonTenthValue()}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Divider(),
                  ShotView(result: widget.result),
                  const SizedBox(height: 6),
                  FloatingActionButton(
                    onPressed: widget.onSave,
                    child: Icon(CupertinoIcons.floppy_disk),
                  )
                ])
              ],
            ));
      },
    );
  }
}