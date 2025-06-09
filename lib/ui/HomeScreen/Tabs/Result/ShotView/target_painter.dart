import 'package:flutter/material.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/ShotView/utils.dart';
import '../../../../../models/shooting/result.dart';
import '../../../../../models/shooting/result_type.dart';

class TargetPainter extends CustomPainter {
  Result result;
  TargetPainter(this.result);
  late double scaler;

  @override
  void paint(Canvas canvas, Size size) {
    scaler = size.width / result.type.getScalerFactor();

    //draw base
    var paint = Paint()
      ..color = Colors.white;
    canvas.drawRect(Offset.zero & Size(size.width, size.height), paint);

    Offset center = Offset(size.width / 2, size.height / 2);

    //draw inner black
    var innerCircle = Paint()
      ..color = Colors.black;
    canvas.drawCircle(center, mmToPixel(result.type.getMirrorWidth() / 2) * scaler, innerCircle);

    //draw value circles
    var circlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 10; i++) {
      circlePaint.color = i <= 6 ? Colors.white : Colors.black;

      double radius = _calcRadius(size, i);

      //draw the value border
      canvas.drawCircle(center, radius, circlePaint);

      //draw the number
      if(i == 0 || i > 8) continue;
      _drawNumber(canvas, size, i, radius, circlePaint.color);
    }
  }

  @override
  bool shouldRepaint(covariant TargetPainter oldDelegate) => result != oldDelegate.result;

  double _calcRadius(Size size, int i) {
    double radius = result.type.getSmallestRadius() + i * result.type.getRadiusDistance();
    return mmToPixel(radius) * scaler;
  }

  void _drawNumber(Canvas canvas, Size size, int i, double radius, Color color) {
    final textStyle = TextStyle(color: color, fontSize: 5);
    final textSpan = TextSpan(text: (9 - i).toString(), style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final offsetLeft = Offset(radius + scaler,
        (size.height /2) - textPainter.height / 2);
    textPainter.paint(canvas, offsetLeft);

    /*final offsetRight = Offset((2 * 48 - radius),
        (size.height /2) - textPainter.height / 2);
    textPainter.paint(canvas, offsetRight);

    final offsetTop = Offset((size.width /2 ) - textPainter.width / 2, radius);
    textPainter.paint(canvas, offsetTop);

    final offsetBottom = Offset((size.width /2 ) - textPainter.width / 2, 2 * 47 - radius);
    textPainter.paint(canvas, offsetBottom);*/
  }
}


extension ResultTypeTargetEx on ResultType {
  int getTargetMultiplier() {
    switch (this) {
      case ResultType.lp10:
      case ResultType.lp20:
      case ResultType.lp40:
      case ResultType.lp60:
        return 10;

      default:
        return 12;
    }
  }
}