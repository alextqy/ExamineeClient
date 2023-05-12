import 'dart:async';

import 'package:flutter/material.dart';
import 'package:client/public/lang.dart';

RawScrollbar scrollbarWidget(dynamic widgets) {
  ScrollController controllerOutside = ScrollController();
  ScrollController controllerInside = ScrollController();
  return RawScrollbar(
    thumbColor: Colors.grey,
    thumbVisibility: true,
    radius: const Radius.circular(0),
    thickness: 10,
    controller: controllerOutside,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controllerOutside,
      child: SingleChildScrollView(
        controller: controllerInside,
        scrollDirection: Axis.vertical,
        child: widgets,
      ),
    ),
  );
}

// ignore: must_be_immutable
class TimerHandler extends StatefulWidget {
  int minutes = 0;
  int seconds = 0;
  TimerHandler({super.key, this.minutes = 0, this.seconds = 0});

  @override
  State<TimerHandler> createState() => TimerHandlerState();
}

class TimerHandlerState extends State<TimerHandler> {
  late int sds;
  late Duration period;
  late Timer _timer;

  /// 数字格式化 将0~9转换为00~09
  String formatTime(int timeNum) {
    return timeNum < 10 ? '0$timeNum' : timeNum.toString();
  }

  /// 时间格式化 hh:mm:ss
  String constructTime(int s) {
    return '${formatTime(s ~/ 3600)}:${formatTime(s % 3600 ~/ 60)}:${formatTime(s % 60)}';
  }

  void run() {
    if (widget.minutes > 0 || widget.seconds > 0) {
      const period = Duration(seconds: 1); // 设置1秒回调一次
      _timer = Timer.periodic(period, (timer) {
        setState(() {
          if (widget.seconds > 0) {
            widget.seconds--;
          }
        });
        /*
        if (widget.seconds == 0) {
          stop();
        }
        */
      });
    }
  }

  void stop() {
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now(); // 获取当期时间
    sds = now.add(Duration(minutes: widget.minutes, seconds: widget.seconds)).difference(now).inSeconds; // 获取指定的时间间隔 并转化秒数
    run();
  }

  @override
  void dispose() {
    super.dispose();
    stop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(constructTime(widget.seconds), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }
}

alertDialog(BuildContext context, {required Widget widget, double w = 100, double h = 100}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, Function state) {
          return AlertDialog(
            title: Text(Lang().title),
            content: SizedBox(width: w, height: h, child: widget),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(Lang().cancel),
              ),
            ],
          );
        },
      );
    },
  );
}
