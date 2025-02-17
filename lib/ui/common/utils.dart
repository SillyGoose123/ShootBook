import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

void showSnackBarError(String msg, BuildContext context) {
  AnimatedSnackBar.material(
    msg,
    type: AnimatedSnackBarType.error,
    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      mobilePositionSettings: const MobilePositionSettings(
      bottomOnAppearance: 80,
      ),
    duration: Duration(seconds: 5)
  ).show(context);
}

showPage(Widget page, BuildContext context) {
  Navigator.push(
      context,
      createPageRoute(page));
}

PageRouteBuilder createPageRoute(Widget page) {
  return PageRouteBuilder(
      transitionsBuilder:
          (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: Container(color: Colors.black, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => page);
}