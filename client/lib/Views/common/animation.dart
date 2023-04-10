import 'package:flutter/material.dart';

// 淡入淡出
class RouteOpacity extends PageRouteBuilder {
  final Widget widget;
  RouteOpacity(this.widget)
      : super(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) {
              return widget;
            },
            transitionsBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2, Widget child) {
              return FadeTransition(
                opacity: Tween(
                  begin: 0.0,
                  end: 2.0,
                ).animate(CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn)),
                child: child,
              );
            });
}

// 滑动
class RouteSlide extends PageRouteBuilder {
  final Widget widget;

  RouteSlide(this.widget)
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) {
            return widget;
          },
          transitionsBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(
                CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn),
              ),
              child: child,
            );
          },
        );
}
