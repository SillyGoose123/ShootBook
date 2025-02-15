import 'package:flutter/material.dart';

void showSnackBarError(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
        child: Text(
          msg,
          style: const TextStyle(color: Colors.redAccent),
        )),
    duration: Durations.extralong2,
    backgroundColor: const Color(0xff111318),
  ));
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