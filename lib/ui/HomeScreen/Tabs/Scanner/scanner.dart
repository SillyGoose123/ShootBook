import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/disag/disag_client.dart';
import "package:shootbook/localizations/app_localizations.dart";
import 'package:shootbook/models/backup/backup_client.dart';
import 'package:shootbook/models/model_saver.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Scanner/scanner_popup.dart';
import 'package:shootbook/disag/disag_login.dart';
import 'package:shootbook/ui/common/utils.dart';
import '../../../../models/shooting/result.dart';
import '../../homescreen.dart';

class Scanner extends StatefulWidget {
  final CupertinoTabController tabController;
  final int myIndex;

  const Scanner(
      {super.key, required this.tabController, required this.myIndex});

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool _login = false;
  DisagClient? _client;
  final MobileScannerController _scanController =
      MobileScannerController(autoStart: true, useNewCameraSelector: true);
  late AppLocalizations _locale;
  Result? scannedResult;
  String? curUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tryLogin();
  }

  @override
  void initState() {
    super.initState();

    //detect when tab is open again
    widget.tabController.addListener(() {
      if (widget.tabController.index == widget.myIndex) {
        _scanController.start();
        _tryLogin();
      } else {
        _scanController.pause();
      }
    });
  }

  Future<void> _tryLogin() async {
    setState(() {
      _login = false;
    });

    try {
      var tempClient =
          await DisagClient.getInstance(AppLocalizations.of(context)!);
      setState(() {
        _client = tempClient;
      });
    } catch (e) {
      setState(() {
        _client = null;
        _login = true;
      });
    }
  }

  Future<void> _onSaveHandler() async {
    try {
      ModelSaver saver = await ModelSaver.getInstance();
      await saver.save(scannedResult!);

      BackupClient? client = await BackupClient.getInstance();
      if(client != null) {
        client.add(scannedResult!);
      }

      widget.tabController.index = TabIndex.results;
    } on ResultAlreadyStoredException catch (e) {
      if (mounted) showSnackBarError(_locale.resultAlreadyStored, context);
    }

    setState(() {
      scannedResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _locale = AppLocalizations.of(context)!;

    if (_client == null && _login) {
      return DisagLogin(
          onLogin: (DisagClient client) => setState(() {
                _client = client;
              }));
    }

    if (_client == null) {
      return Center(child: CircularProgressIndicator());
    }

    if(scannedResult != null) {
      curUrl = null;
    }

    return AiBarcodeScanner(
        hideSheetDragHandler: true,
        hideSheetTitle: true,
        onDetect: _detectHandler,
        validator: _validate,
        hideGalleryButton: true,
        controller: _scanController,
        bottomSheetBuilder: (context, controller) => scannedResult == null
            ? SizedBox.shrink()
            : ScannerBottomSheet(
                result: scannedResult!, onSave: _onSaveHandler));
  }

  Future<void> _detectHandler(BarcodeCapture capture) async {
    final scanUrl = capture.barcodes[0].displayValue;

    if (scanUrl == null || curUrl != null || scanUrl == curUrl) {
      return;
    }

    curUrl = scanUrl;

    try {
      DisagClient client = await DisagClient.getInstance(_locale);
      Result result = await client.getQrCodeDataPreview(scanUrl);

      setState(() {
        scannedResult = result;
      });
    } on TokenException catch (e) {
      setState(() {
        scannedResult = null;
        _login = true;
      });
    }
  }

  bool _validate(BarcodeCapture capture) {
    return capture.barcodes[0].displayValue
        ?.startsWith("https://qr.shotsapp.de/?uuid=") ??
        false;
  }
}
