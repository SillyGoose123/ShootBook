import "dart:async";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import "package:shootbook/disag/disag_client.dart";
import "package:shootbook/disag/disag_login.dart";
import "package:shootbook/ui/HomeScreen/Tabs/Scanner/scanner_overlay.dart";
import "package:shootbook/ui/HomeScreen/Tabs/Scanner/scanner_popup.dart";

import "../../../../localizations/app_localizations.dart";
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
  MobileScannerController controller = MobileScannerController(
      formats: BarcodeFormat.values, useNewCameraSelector: true, cameraResolution: Size(1920, 1080));
  bool _login = false;
  String? _curUrl;
  Widget? bottomSheet;
  DisagClient? _client;
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (widget.tabController.index == widget.myIndex) {
        controller.setZoomScale(0);
        setState(() {
          _currentSliderValue = 0;
        });
        controller.start();
      } else {
        controller.pause();
      }

      bottomSheet = null;
      _curUrl = null;
    });
  }

  Future<void> _onSaveHandler(Result scannedResult, String url) async {
    try {
      _client!.acceptResult(url);
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
            result: scannedResult,
            onSave: () => _onSaveHandler(scannedResult, url));
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
              icon: const Icon(CupertinoIcons.arrow_2_circlepath),
              onPressed: () {
                controller.setZoomScale(0);
                setState(() {
                  _currentSliderValue = 0;
                });
              },
            ),
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
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox.shrink(),
            Center(
                child: CustomPaint(
              foregroundPainter: BorderPainter(),
              child: SizedBox(
                width: scanSize,
                height: scanSize,
              ),
            )),
            SliderTheme(
                data: SliderThemeData(
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 14.0,
                      pressedElevation: 8.0,
                    ),
                    activeTrackColor: Color.fromRGBO(68, 138, 255, 0.1),
                    inactiveTrackColor: Color.fromRGBO(68, 138, 255, 0.1),
                    thumbColor: Color.fromRGBO(19, 60, 150, 1.0)),
                child: Padding(
                    padding: EdgeInsets.only(left: screenSize.width / 8),
                    child: SizedBox(
                        width: screenSize.width / 2,
                        child: Slider(
                          value: _currentSliderValue,
                          max: 100,
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                            controller.setZoomScale(value / 100);
                          },
                        )))),
          ])
        ]));
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}
