// https://api.flutter.dev/flutter/dart-ui/FlutterView/devicePixelRatio.html
// fFlutter works with logical pixels where 1cm == 39px

double mmToPixel(double mm) {
  return mm * (38 / 10);
}

double pixelToMm(double pixels) {
  return  pixels / (38 / 10);
}

