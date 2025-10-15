import 'package:flutter/material.dart';

extension AddonsFunctions on BuildContext {
  double width() => MediaQuery.sizeOf(this).width;
  double height() => MediaQuery.sizeOf(this).height;

  Future<dynamic> goTo(Widget screen) async {
    return await Navigator.push(this, _build(screen));
  }

  Future<dynamic> goOff(Widget screen) async {
    return await Navigator.pushReplacement(this, _build(screen));
  }

  Future<dynamic> goOffAll(Widget screen) async {
    return await Navigator.pushAndRemoveUntil(
      this,
      _build(screen),
      (route) => false,
    );
  }

  PageRoute _build(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(animation),
          child: child,
        );
      },
    );
  }
}
