import 'package:flutter/material.dart';
import 'package:shootbook/models/shooting/result.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/ShotView/shoot_painter.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Result/ShotView/target_painter.dart';

class ShotView extends StatefulWidget {
  final Result result;
  final int size;

  const ShotView({super.key, required this.result, required this.size});

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
          size: Size(widget.size.toDouble(), widget.size.toDouble()),
        ),
      );
  }
}