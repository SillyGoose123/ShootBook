import "dart:async";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import "package:shootbook/disag/disag_client.dart";
import "package:shootbook/disag/disag_login.dart";
import "package:shootbook/ui/HomeScreen/Tabs/Scanner/scanner_overlay.dart";
import "package:shootbook/ui/HomeScreen/Tabs/Scanner/scanner_popup.dart";

import "../../../../localizations/app_localizations.dart";
import "../../../../models/backup/backup_client.dart";
import "../../../../models/model_saver.dart";
import "../../../../models/shooting/result.dart";
import "../../../common/utils.dart";
import "../../homescreen.dart";

class Scanner extends StatefulWidget {
  final CupertinoTabController tabController;
  final int myIndex;

  const Scanner(
      {super.key, required this.tabController, required this.myIndex});

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  late AppLocalizations _locale;
  final MobileScannerController controller =
      MobileScannerController(formats: BarcodeFormat.values);
  bool _login = false;
  String? _curUrl;
  Widget? bottomSheet;
  DisagClient? _client;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (widget.tabController.index == widget.myIndex) {
        controller.start();
      } else {
        controller.pause();
      }

      bottomSheet = null;
      _curUrl = null;
    });
  }

  Future<void> _onSaveHandler(Result scannedResult) async {
    try {
      ModelSaver saver = await ModelSaver.getInstance();
      await saver.save(scannedResult);

      BackupClient? client = await BackupClient.getInstance();
      if (client != null) {
        client.add(scannedResult);
      }
    } on ResultAlreadyStoredException catch (e) {
      if (mounted) showSnackBarError(_locale.resultAlreadyStored, context);
      return;
    }

    widget.tabController.index = TabIndex.results;
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    String url = capture.barcodes.last.url!.url;

    if (url == _curUrl) return;

    try {
      Result scannedResult =
          await _client!.getQrCodeDataPreview(capture.barcodes.last.url!.url);

      if (!mounted) return;
      setState(() {
        bottomSheet = ScannerBottomSheet(
            result: scannedResult, onSave: () => _onSaveHandler(scannedResult));
      });
      _curUrl = url;
    } catch (e) {
      if (!mounted || _login) return;
      showSnackBarError(_locale.loginFailed, context);
      setState(() {
        _login = true;
        _curUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _locale = AppLocalizations.of(context)!;

    if (_client == null) {
      DisagClient.getInstance(_locale)
          .then((client) => setState(() {
                _client = client;
              }))
          .catchError((e) {
        setState(() {
          _login = true;
        });
      });

      return Center(child: CircularProgressIndicator());
    }

    if (_login) {
      return PopScope(
          canPop: false,
          child: DisagLogin(onLogin: (DisagClient client) {
            setState(() {
              _login = false;
              _client = client;
            });
          }));
    }

    Size screenSize = MediaQuery.of(context).size;
    double scanSize = screenSize.width - (screenSize.width * 0.25);

    controller.start();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.cameraswitch_rounded),
              onPressed: controller.switchCamera,
            ),
            IconButton(
              icon: controller.torchEnabled
                  ? const Icon(Icons.flashlight_off_rounded)
                  : const Icon(Icons.flashlight_on_rounded),
              onPressed: controller.toggleTorch,
            ),
          ],
        ),
        bottomSheet: bottomSheet,
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover,
            onDetect: _onDetect,
          ),
          Center(child: CustomPaint(
            foregroundPainter: BorderPainter(),
            child: SizedBox(
              width: scanSize,
              height: scanSize,
            ),
          ))
        ]));
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}
