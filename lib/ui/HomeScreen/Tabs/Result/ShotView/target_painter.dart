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
      circlePaint.color = i < result.type.mirrorNumberAmount ? Colors.white : Colors.black;

      double radius = _calcRadius(size, i);

      //draw the value border
      canvas.drawCircle(center, radius, circlePaint);

      //draw the number
      if(i == 9 || i == 0) continue;
      _drawNumber(canvas, size, i, radius);
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

  void _drawNumber(Canvas canvas, Size size, int i, double radius) {
    final color = i > 3 ? Colors.white : Colors.black;
    final textStyle = TextStyle(color: color, fontSize: 5 * scaler);
    final textSpan = TextSpan(text: (i).toString(), style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    double halfSize = size.height /2;

    //magic
    final offsetLeft = Offset(radius - textPainter.width - 2 *scaler,
        halfSize - textPainter.height / 2);
    textPainter.paint(canvas, offsetLeft);

    final offsetRight = Offset(size.width - offsetLeft.dx - textPainter.width,
        halfSize - textPainter.height / 2);
    textPainter.paint(canvas, offsetRight);

    final offsetTop = Offset(halfSize - textPainter.width / 2, radius - textPainter.height - scaler);
    textPainter.paint(canvas, offsetTop);

    final offsetBottom = Offset(
      halfSize - textPainter.width / 2,  size.width - textPainter.height - offsetTop.dy
    );
    textPainter.paint(canvas, offsetBottom);
  }
}