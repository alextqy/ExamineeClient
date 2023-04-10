// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';

enum Position {
  TOP,
  CENTER,
  BOTTOM,
}

// 自定义内容
Widget customToastContent(String message, {double textSize = 14, Color textColor = Colors.white}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Icon(
        Icons.info,
        color: Colors.blue,
        size: 25,
      ),
      Flexible(
          child: Padding(
        padding: EdgeInsets.only(left: message.isEmpty ? 0 : 10),
        child: Text(
          message,
          style: TextStyle(fontSize: textSize, color: textColor),
        ),
      ))
    ],
  );
}

class Toast {
  OverlayEntry? _overlayEntry; // 浮层
  Position? _toastPosition; // 显示位置
  Timer? _mTimer; // 计时 如果计时大于_seconds则移除Toast
  int _seconds = 0; // 时长单位 秒

  void show(
    BuildContext context, {
    required String message,
    Color color = Colors.black,
    Color textColor = Colors.white,
    double textSize = 14.0,
    int seconds = 2,
    Position position = Position.BOTTOM, // 显示位置
    Widget? child,
  }) async {
    _toastPosition = position;
    _seconds = seconds;

    _cancelToast();
    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
          //top值，可以改变这个值来改变toast在屏幕中的位置
          top: _getToastPosition(context),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Center(
                child: Card(
                  color: color, //背景色
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: textSize,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
    _startTimer();
    overlayState.insert(_overlayEntry!);
  }

  // 开启倒计时
  void _startTimer() {
    _cancelTimer();
    _mTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick > _seconds) {
        _cancelTimer();
        _cancelToast();
      }
    });
  }

  // 取消倒计时
  void _cancelTimer() async {
    _mTimer?.cancel();
    _mTimer = null;
  }

  // 移除Toast
  void _cancelToast() async {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // 设置toast位置
  double _getToastPosition(context) {
    double position;
    if (_toastPosition == Position.TOP) {
      position = MediaQuery.of(context).size.height * 1 / 6;
    } else if (_toastPosition == Position.CENTER) {
      position = MediaQuery.of(context).size.height * 3 / 6;
    } else {
      position = MediaQuery.of(context).size.height * 5 / 6;
    }
    return position;
  }

  // 判断是否是暗黑模式
  // bool isDarkMode() {
  //   bool isDarkMode;
  //   const ThemeMode themeMode = ThemeMode.system;
  //   if (themeMode == ThemeMode.light || themeMode == ThemeMode.dark) {
  //     isDarkMode = themeMode == ThemeMode.dark;
  //   } else {
  //     isDarkMode =
  //         WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  //   }
  //   return isDarkMode;
  // }
}
