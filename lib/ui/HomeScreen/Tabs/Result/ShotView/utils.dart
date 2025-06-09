// https://api.flutter.dev/flutter/dart-ui/FlutterView/devicePixelRatio.html
// flutters logical pixels which means 38 pixel are on centimeter

double mmToPixel(double mm) {
  return (mm / 10) * 38;
}

