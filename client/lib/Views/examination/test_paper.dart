import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/public/lang.dart';
import 'package:client/public/tools.dart';
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
  ScrollController listViewController = ScrollController();
  int currentItemID = 0;
  double currentListOffset = 0;

  basicListener() async {
    if (examineeTokenNotifier.operationStatus.value == OperationStatus.loading) {
      showSnackBar(context, content: Lang().loading);
    } else if (examineeTokenNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().theOperationCompletes);
    } else {
      showSnackBar(context, content: examineeTokenNotifier.operationMemo);
    }
  }

  void fetchData() {
    examineeTokenNotifier.examScantronList().then((value) {
      setState(() {
        examineeTokenNotifier.scantronListModel = ScantronModel().fromJsonList(jsonEncode(value.data));
      });
    });
  }

  Widget generateList(BuildContext context, int index) {
    ListTile listTileWidget = ListTile(
      key: ValueKey(Tools().genMD5(examineeTokenNotifier.scantronListModel[index].id.toString())),
      title: Container(
        color: currentItemID == index ? Colors.black : null,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(0),
        alignment: Alignment.center,
        child: Row(
          children: [
            examineeTokenNotifier.scantronListModel[index].headlineContent == 'none' ? const SizedBox(width: 10) : const Expanded(child: SizedBox()),
            Icon(
              currentItemID == index ? Icons.my_location_outlined : Icons.radio_button_unchecked_outlined,
              size: examineeTokenNotifier.scantronListModel[index].headlineContent == 'none' ? 15 : 0,
              color: Colors.white,
            ),
            SizedBox(width: examineeTokenNotifier.scantronListModel[index].headlineContent == 'none' ? 15 : 0),
            SizedBox(
              width: 180,
              child: Text(
                examineeTokenNotifier.scantronListModel[index].headlineContent == 'none' ? examineeTokenNotifier.scantronListModel[index].questionTitle : examineeTokenNotifier.scantronListModel[index].headlineContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: examineeTokenNotifier.scantronListModel[index].headlineContent == 'none' ? TextAlign.left : TextAlign.center,
                style: TextStyle(
                  color: examineeTokenNotifier.scantronListModel[index].headlineContent == 'none' ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: examineeTokenNotifier.scantronListModel[index].headlineContent == 'none' ? 15 : 20,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          currentItemID = index;
          currentListOffset = listViewController.offset;
        });
      },
    );
    return listTileWidget;
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
      width: 280,
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
            child: ListView.builder(
              controller: listViewController,
              padding: const EdgeInsets.all(0),
              itemCount: examineeTokenNotifier.scantronListModel.length,
              itemBuilder: (BuildContext context, int index) {
                return generateList(context, index);
              },
            ),
          ),
          Container(height: 1.0, color: Colors.white),
          Container(
            margin: const EdgeInsets.all(0),
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 140,
                  child: IconButton(
                    iconSize: 18,
                    icon: const Icon(Icons.my_location_outlined),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        // 滚动到指定位置
                        listViewController.animateTo(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutQuart,
                          currentListOffset,
                        );
                      });
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  height: 40,
                  width: 140,
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
                    },
                  ),
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
