import 'package:flutter/material.dart';

import '../../../../../models/shooting/result.dart';
import '../../../../../models/shooting/shot.dart';

class ShootPainter extends CustomPainter {
  Result result;

  ShootPainter(this.result);

  @override
  void paint(Canvas canvas, Size size) {
   /* var shootPaint = Paint();

    for(Shot shot in result.getAllShots()) {
      shootPaint.color = shot.getValueColor();
      canvas.drawCircle(shot.getOffsetCoordinate(size), 5, shootPaint);
    }*/
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