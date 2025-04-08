import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/disag/disag_client.dart';
import 'package:shootbook/localizations/app_localizations.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/shot_view.dart';
import 'package:shootbook/ui/common/utils.dart';
import '../../../../models/shooting/result.dart';

class ScannerBottomSheet extends StatefulWidget {
  final String resultUrl;
  final void Function(bool) reset;

  const ScannerBottomSheet(
      {super.key, required this.resultUrl, required this.reset});

  @override
  State<ScannerBottomSheet> createState() => _ScannerBottomSheetState();
}

class _ScannerBottomSheetState extends State<ScannerBottomSheet> {
  bool hadError = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result>(
        future: _fetchPreview(context),
        builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ) {
            return BottomSheet(
                onClosing: () {},
                builder: (context) =>
                     Padding(
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator()));
          }

          if (snapshot.hasError || snapshot.data == null) {
            if(!hadError) showSnackBarError(AppLocalizations.of(context)!.qrCodeScanFailed, context);
            hadError = true;
            return SizedBox.shrink();
          }

          hadError = false;
          Result result = snapshot.data!;

          return DraggableScrollableSheet(
            initialChildSize: 0.42,
            minChildSize: 0.03,
            maxChildSize: 0.42,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                  color: Colors.black26,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Column(spacing: 6, children: [
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
                        Text(
                          "${result.type.toText()} ${result.calcNonTenthValue()}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        ShotView(result: result),
                        FloatingActionButton(
                          onPressed: _handleSave,
                          child: Icon(CupertinoIcons.floppy_disk),
                        )
                      ])
                    ],
                  ));
            },
          );
        });
  }

  Future<Result> _fetchPreview(BuildContext context) async {
    DisagClient client =
        await DisagClient.getInstance(AppLocalizations.of(context)!);
    return await client.getQrCodeDataPreview(widget.resultUrl);
  }

  Future<void> _handleSave() async {
    if (!mounted) return;
    AppLocalizations locale = AppLocalizations.of(context)!;
    try {
      DisagClient client =
      await DisagClient.getInstance(locale);
      await client.acceptResult(widget.resultUrl);
      widget.reset(true);
      return;
    } on ResultAlreadyStoredException catch(e) {
      if(mounted) showSnackBarError(locale.resultAlreadyStored, context);
    } catch(e) {
      if(mounted) showSnackBarError(locale.saveFailed, context);
    }

    widget.reset(false);
  }
}
