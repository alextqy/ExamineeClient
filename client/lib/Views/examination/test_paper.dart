import 'dart:convert';

import 'package:flutter/material.dart';
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

  List<ListTile> generateList() {
    List<ListTile> scantronListTile = [];
    for (ScantronModel element in examineeTokenNotifier.scantronListModel) {
      String title = element.headlineContent == 'none' ? element.questionTitle : element.headlineContent;
      double titleFontSize = element.headlineContent == 'none' ? 15 : 20;
      TextAlign textAlign = element.headlineContent == 'none' ? TextAlign.left : TextAlign.center;
      bool enabledItem = element.headlineContent == 'none' ? true : true;
      Color textColor = element.headlineContent == 'none' ? Colors.white : Colors.grey;
      scantronListTile.add(
        ListTile(
          enabled: enabledItem,
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlign,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: titleFontSize),
          ),
          onTap: () {
            if (enabledItem) {
              print(element.id);
            }
          },
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
      width: 350,
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: Text(
              Lang().testQuestions,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Container(height: 1.0, color: Colors.white),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: generateList(),
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
