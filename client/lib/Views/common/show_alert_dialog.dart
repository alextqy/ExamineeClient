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
            title: Text(Lang().title),
            content: Text(memo),
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
