import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

void showSnackBarError({required String msg, required BuildContext context,
    MobileSnackBarPosition? position}) {
  AnimatedSnackBar.material(
    msg,
    type: AnimatedSnackBarType.error,
    mobileSnackBarPosition: position ?? MobileSnackBarPosition.bottom,
      mobilePositionSettings: MobilePositionSettings(
      bottomOnAppearance: 5,
        topOnAppearance: 100
      ),
    snackBarStrategy: RemoveSnackBarStrategy(),
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