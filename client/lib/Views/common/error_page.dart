import 'package:flutter/material.dart';
import 'package:client/public/lang.dart';

Future<String> futureTest = Future.delayed(const Duration(seconds: 1), () {
  return 'Bit Exam';
});

errorPage() {
  Container(
    width: double.infinity,
    height: double.infinity,
    padding: const EdgeInsets.all(0),
    margin: const EdgeInsets.all(0),
    color: Colors.grey,
    child: Center(
      child: Text(
        Lang().theRequestFailed,
        style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
