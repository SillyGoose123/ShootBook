import 'package:flutter/material.dart';
import '../../../../../models/shooting/result.dart';
import '../../../../../models/shooting/result_type.dart';

class TargetPainter extends CustomPainter {
  Result result;
  TargetPainter(this.result);

  @override
  void paint(Canvas canvas, Size size) {
    //draw base
    var paint = Paint()
      ..color = Colors.white;
    canvas.drawRect(Offset.zero & Size(size.width, size.height), paint);

    Offset center = Offset(size.width / 2, size.height / 2);

    //draw inner black
    var innerCircle = Paint()
      ..color = Colors.black;
    canvas.drawCircle(center, size.width / 3.2, innerCircle);


    //draw value circles
    var circlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke;


    for (var i = 0; i < 11; i++) {
      circlePaint.color = i >= 3 ? Colors.white : Colors.black;

      double radius = _calcRadius(size, i);

      //draw the value border
      canvas.drawCircle(center, radius, circlePaint);

      //draw the number
      if(i == 0 || i > 8) continue;
      _drawNumber(canvas, size, 9 - i, radius);
    }
  }

  @override
  bool shouldRepaint(covariant TargetPainter oldDelegate) => result != oldDelegate.result;

  double _calcRadius(Size size, i) {
    /*  print("size: ${size}");
    print("result multiplier: ${(result.type.getTargetMultiplier() / size.width)}");
    print("=${((size.height - (i * result.type.getTargetMultiplier())) / 2)}");*/
    return ((size.height - (i * result.type.getTargetMultiplier())) / 2);
  }

  void _drawNumber(Canvas canvas, Size size, int i, double radius) {
    final textStyle = TextStyle(color: i < 4 ? Colors.black : Colors.white, fontSize: 5);
    final textSpan = TextSpan(text: i.toString(), style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final offsetLeft = Offset((radius + 2),
        (size.height /2) - textPainter.height / 2);
    textPainter.paint(canvas, offsetLeft);

    final offsetRight = Offset((2 * 48 - radius),
        (size.height /2) - textPainter.height / 2);
    textPainter.paint(canvas, offsetRight);

    final offsetTop = Offset((size.width /2 ) - textPainter.width / 2, radius);
    textPainter.paint(canvas, offsetTop);

    final offsetBottom = Offset((size.width /2 ) - textPainter.width / 2, 2 * 47 - radius);
    textPainter.paint(canvas, offsetBottom);
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