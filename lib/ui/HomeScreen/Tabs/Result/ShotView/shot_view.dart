import 'package:flutter/material.dart';
import 'package:shootbook/models/shooting/result.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/ShotView/shoot_painter.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/ShotView/target_painter.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/ShotView/utils.dart';

class ShotView extends StatefulWidget {
  final Result result;
  final double size;

  const ShotView({super.key, required this.result, required this.size});

  @override
  State<ShotView> createState() => _ShotViewState();
}

class _ShotViewState extends State<ShotView> {
  @override
  Widget build(BuildContext context) {
    double scalar = pixelToMm(widget.size - 5) / widget.result.type.targetWidth;
    return
      ClipRRect(
        borderRadius: BorderRadius.circular(20), // Adjust radius as needed
        child: CustomPaint(
          foregroundPainter: ShootPainter(widget.result, scalar),
          painter: TargetPainter(widget.result, scalar),
          size: Size(widget.size, widget.size),
        ),
      );
  }
}