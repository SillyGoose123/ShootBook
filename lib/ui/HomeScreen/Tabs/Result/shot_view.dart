import 'package:flutter/material.dart';
import 'package:shootbook/models/shooting/result.dart';

import '../../../../models/shooting/shot.dart';

class ShotView extends StatefulWidget {
  final Result result;

  const ShotView({super.key, required this.result});

  @override
  State<ShotView> createState() => _ShotViewState();
}

class _ShotViewState extends State<ShotView> {
  @override
  Widget build(BuildContext context) {
    return
      ClipRRect(
        borderRadius: BorderRadius.circular(20), // Adjust radius as needed
        child: CustomPaint(
          foregroundPainter: ShootPainter(widget.result),
          painter: TargetPainter(widget.result),
          size: Size(200, 200),
        ),
      );
  }
}

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
    throw UnimplementedError();
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


class ShootPainter extends CustomPainter {
  Result result;

  ShootPainter(this.result);

  @override
  void paint(Canvas canvas, Size size) {
    var shootPaint = Paint();

    for(Shot shot in result.getAllShots()) {
      shootPaint.color = shot.getValueColor();
      canvas.drawCircle(shot.getOffsetCoordinate(size), 5, shootPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ShootPainter oldDelegate) =>
      result != oldDelegate.result;
}

extension ShotTargetEx on Shot {
  Color getValueColor() {
    switch (value.truncate()){
      case 9:
        return Colors.yellow;

      case 10:
        return Colors.red;

      default:
        return Colors.green;
    }
  }

  Offset getOffsetCoordinate(Size size) {
    double shift = 50;
    double a = 100 - size.width / 2;
    double x = this.x / a + shift;
    double y = 2 * a - (this.y / a + shift);

   /* print("x: $x, y: $y, a: $a");*/

    return Offset(x, y);
  }
}