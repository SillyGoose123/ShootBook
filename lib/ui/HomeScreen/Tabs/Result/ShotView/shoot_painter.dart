import 'package:flutter/material.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/ShotView/utils.dart';

import '../../../../../models/shooting/result.dart';
import '../../../../../models/shooting/shot.dart';

class ShootPainter extends CustomPainter {
  final Result result;
  final double scalar;

  ShootPainter(this.result, this.scalar);

  @override
  void paint(Canvas canvas, Size size) {
   var shootPaint = Paint();

    for(Shot shot in result.getAllShots()) {
      shootPaint.color = shot.getValueColor().withAlpha(225);
      print("rawX: ${shot.x.toDouble()}, rawY: ${shot.y.toDouble()}, scalar: $scalar");
      double x = convertCoordinates(shot.x.toDouble(), size);
      double y = size.width - convertCoordinates(shot.y.toDouble(), size); // mirror on y axes because disag
      print("x: $x, y: $y");
      canvas.drawCircle(Offset(x, y), mmToPixel(result.type.shotRadius), shootPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ShootPainter oldDelegate) =>
      result != oldDelegate.result;

  double convertCoordinates(double cord, Size size) {
    return mmToPixel(cord / result.type.targetWidth / scalar) + size.width / 2;
  }
}


extension ShotTargetEx on Shot {
  Color getValueColor() {
    switch (value.truncate()){
      case 10:
        return Colors.red;

      case 9:
        return Colors.yellow.shade600;

      case 8:
        return Colors.green;

      default:
        return Colors.green.shade800;
    }
  }
}