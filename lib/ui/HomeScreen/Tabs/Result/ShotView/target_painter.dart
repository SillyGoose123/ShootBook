import 'package:flutter/material.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/ShotView/utils.dart';
import '../../../../../models/shooting/result.dart';

class TargetPainter extends CustomPainter {
  Result result;
  TargetPainter(this.result);
  late final double scaler;

  @override
  void paint(Canvas canvas, Size size) {
    scaler = pixelToMm(size.width - 5) / result.type.targetWidth;

    //draw base
    var paint = Paint()
      ..color = Colors.white;
    canvas.drawRect(Offset.zero & size, paint);

    final Offset center = Offset(size.width / 2, size.height / 2);

    //draw inner black
    var innerCircle = Paint()
      ..color = Colors.black;
    canvas.drawCircle(center, mmToPixel(result.type.mirrorRadius * scaler), innerCircle);


    //draw value circles
    var circlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = mmToPixel(0.25)
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 10; i++) {
      circlePaint.color = i < result.type.inAmountBlack ? Colors.white : Colors.black;

      double radius = _calcRadius(size, i);

      //draw the value border
      canvas.drawCircle(center, radius, circlePaint);

      //draw the number
      if(i >= 8 || size.width < 150) continue;
      _drawNumber(canvas, size, i);
    }

    //draw inner ten
    double? innerTen = result.type.innerTenRadius;
    if(innerTen != null) {
      circlePaint.color = Colors.white;
      canvas.drawCircle(center, innerTen, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant TargetPainter oldDelegate) => result != oldDelegate.result;

  double _calcRadius(Size size, int i) {
    double radius = result.type.radiusOf10 + i * result.type.valueDistance;
    return mmToPixel(radius * scaler);
  }

  double _calcNumberX(Size size, int i) {
    return mmToPixel(result.type.valueDistance * scaler) * i + 2.5;
  }

  void _drawNumber(Canvas canvas, Size size, int i) {
    int displayedNumber = i + 1;
    final color =  (10 - result.type.mirrorNumberAmount) - 1 <= displayedNumber ? Colors.white : Colors.black;
    final textStyle = TextStyle(color: color, fontSize: result.type.valueDistance * 2 * scaler);
    final textSpan = TextSpan(text: displayedNumber.toString(), style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // count up from the left
    double x = _calcNumberX(size, i);
    double between = _calcNumberX(size, i + 1) - x;
    x = x + between / 2;

    double halfSize = size.height / 2;

    double midY = halfSize - textPainter.height / 2;
    final offsetLeft = Offset(x - textPainter.width / 2, midY);
    textPainter.paint(canvas, offsetLeft);

    final offsetRight = Offset(size.width - offsetLeft.dx - textPainter.width,
        midY);
    textPainter.paint(canvas, offsetRight);

    double midX = halfSize - textPainter.width / 2;
    final offsetTop = Offset(midX, x - textPainter.height / 2);
    textPainter.paint(canvas, offsetTop);

    final offsetBottom = Offset(
        midX,  size.width - offsetTop.dy - textPainter.height
    );
    textPainter.paint(canvas, offsetBottom);
  }
}