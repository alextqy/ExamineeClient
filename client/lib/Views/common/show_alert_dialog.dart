import 'package:flutter/material.dart';
import 'package:client/public/lang.dart';

showAlertDialog(BuildContext context, {String memo = ''}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, Function state) {
          return AlertDialog(
            title: Text(style: const TextStyle(fontWeight: FontWeight.bold), Lang().title),
            content: Text(style: const TextStyle(fontWeight: FontWeight.bold), memo),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(style: const TextStyle(fontWeight: FontWeight.bold), Lang().cancel),
              ),
            ],
          );
        },
      );
    },
  );
}

ScaffoldFeatureController showSnackBar(BuildContext context, {String content = ''}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        content,
      ),
      // action: SnackBarAction(label: 'Action', onPressed: () {}),
    ),
  );
}
