import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/public/lang.dart';
import 'package:client/Views/common/show_alert_dialog.dart';

import 'package:client/providers/base_notifier.dart';
import 'package:client/providers/examinee_token_notifier.dart';

import 'package:client/models/scantron_model.dart';

// ignore: must_be_immutable
class TestPaper extends StatefulWidget {
  const TestPaper({super.key});

  @override
  State<TestPaper> createState() => TestPaperState();
}

class TestPaperState extends State<TestPaper> {
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();

  basicListener() async {
    if (examineeTokenNotifier.operationStatus.value == OperationStatus.loading) {
      showSnackBar(context, content: Lang().loading);
    } else if (examineeTokenNotifier.operationStatus.value == OperationStatus.success) {
      // fetchData();
      showSnackBar(context, content: Lang().theOperationCompletes);
    } else {
      showSnackBar(context, content: examineeTokenNotifier.operationMemo);
    }
  }

  void fetchData() {
    examineeTokenNotifier.examScantronList().then((value) {
      setState(() {
        examineeTokenNotifier.scantronListModel = ScantronModel().fromJsonList(jsonEncode(value.data));
        if (examineeTokenNotifier.scantronListModel.isNotEmpty) {
          generateList();
        }
      });
    });
  }

  List<Container> generateList() {
    List<Container> scantronListTile = [];
    for (ScantronModel element in examineeTokenNotifier.scantronListModel) {
      Widget frontWidget = element.headlineContent == 'none' ? const SizedBox(width: 10) : const Expanded(child: SizedBox());
      double titleIconSize = element.headlineContent == 'none' ? 15 : 0;
      double titleIconSpace = element.headlineContent == 'none' ? 20 : 0;
      String title = element.headlineContent == 'none' ? element.questionTitle : element.headlineContent;
      double titleFontSize = element.headlineContent == 'none' ? 15 : 20;
      TextAlign textAlign = element.headlineContent == 'none' ? TextAlign.left : TextAlign.center;
      Color textColor = element.headlineContent == 'none' ? Colors.white : Colors.grey;
      scantronListTile.add(
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              frontWidget,
              Icon(Icons.radio_button_unchecked_outlined, size: titleIconSize),
              SizedBox(width: titleIconSpace),
              InkWell(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: textAlign,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: titleFontSize),
                ),
                onTap: () => print(element.id),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return scantronListTile;
  }

  @override
  void initState() {
    super.initState();
    examineeTokenNotifier.addListener(basicListener);
    fetchData();
  }

  @override
  void dispose() {
    examineeTokenNotifier.dispose();
    examineeTokenNotifier.removeListener(basicListener);
    super.dispose();
  }

  Drawer questions(BuildContext context) {
    return Drawer(
      width: 300,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: SizedBox(
              height: 30,
              child: Text(
                Lang().testQuestions,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          Container(height: 1.0, color: Colors.white),
          Expanded(
            child: ListView(padding: const EdgeInsets.all(0), children: generateList()),
          ),
          Container(height: 1.0, color: Colors.white),
          Container(
            margin: const EdgeInsets.all(0),
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 150,
                  child: IconButton(iconSize: 18, icon: const Icon(Icons.my_location_outlined), onPressed: () => print('focus')),
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  height: 40,
                  width: 150,
                  child: TextButton(
                      child: Text(Lang().exit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: Text(style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), '${Lang().exit} ?'),
                              content: const Column(
                                children: <Widget>[
                                  // const SizedBox(height: 10),
                                  // Align(alignment: const Alignment(0, 0), child: Text(style: const TextStyle(fontWeight: FontWeight.bold), Lang().none)),
                                ],
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  isDestructiveAction: false,
                                  child: Text(style: const TextStyle(fontWeight: FontWeight.bold), Lang().cancel),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  child: Text(style: const TextStyle(fontWeight: FontWeight.bold), Lang().confirm),
                                  onPressed: () {
                                    exit(0);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      color: Colors.grey,
      child: Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(10),
        color: Colors.white70,
        child: const Row(
          children: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: questions(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Lang().title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: mainWidget(context),
    );
  }
}
