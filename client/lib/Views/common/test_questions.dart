// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:client/models/scantron_model.dart';
import 'package:client/models/scantron_solution_model.dart';
import 'package:flutter/material.dart';
import 'package:client/providers/examinee_token_notifier.dart';

/// 单选
/// ===============================================================================================================================================================

class MultipleChoice extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String headlineContent;
  String description;
  String attachment;
  MultipleChoice({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.headlineContent,
    required this.description,
    required this.attachment,
  });

  @override
  State<MultipleChoice> createState() => MultipleChoiceState();
}

class MultipleChoiceState extends State<MultipleChoice> {
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();

  void fetchData() {
    examineeTokenNotifier.examScantronSolutionInfo(id: widget.id).then((value) {
      setState(() {
        examineeTokenNotifier.scantronSolutionListModel = ScantronSolutionModel().fromJsonList(jsonEncode(value.data));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.questionTitle,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  widget.description,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget(context);
  }
}

/// 判断
/// ===============================================================================================================================================================

class JudgmentQuestions extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String headlineContent;
  String description;
  String attachment;
  JudgmentQuestions({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.headlineContent,
    required this.description,
    required this.attachment,
  });

  @override
  State<JudgmentQuestions> createState() => JudgmentQuestionsState();
}

class JudgmentQuestionsState extends State<JudgmentQuestions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: const Center(child: Text('JudgmentQuestions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget(context);
  }
}

/// 多选
/// ===============================================================================================================================================================

class MultipleSelection extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String headlineContent;
  String description;
  String attachment;
  MultipleSelection({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.headlineContent,
    required this.description,
    required this.attachment,
  });

  @override
  State<MultipleSelection> createState() => MultipleSelectionState();
}

class MultipleSelectionState extends State<MultipleSelection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: const Center(child: Text('MultipleSelection', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget(context);
  }
}

/// 填空
/// ===============================================================================================================================================================

class FillInTheBlanks extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String headlineContent;
  String description;
  String attachment;
  FillInTheBlanks({
    required this.id,
    super.key,
    required this.questionTitle,
    required this.score,
    required this.headlineContent,
    required this.description,
    required this.attachment,
  });

  @override
  State<FillInTheBlanks> createState() => FillInTheBlanksState();
}

class FillInTheBlanksState extends State<FillInTheBlanks> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: const Center(child: Text('FillInTheBlanks', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget(context);
  }
}

/// 问答
/// ===============================================================================================================================================================

class QuizQuestions extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String headlineContent;
  String description;
  String attachment;
  QuizQuestions({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.headlineContent,
    required this.description,
    required this.attachment,
  });

  @override
  State<QuizQuestions> createState() => QuizQuestionsState();
}

class QuizQuestionsState extends State<QuizQuestions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: const Center(child: Text('QuizQuestions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget(context);
  }
}

/// 代码测试
/// ===============================================================================================================================================================

class CodeTesting extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String headlineContent;
  String description;
  String attachment;
  CodeTesting({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.headlineContent,
    required this.description,
    required this.attachment,
  });

  @override
  State<CodeTesting> createState() => CodeTestingState();
}

class CodeTestingState extends State<CodeTesting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: const Center(child: Text('CodeTesting', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget(context);
  }
}

/// 拖拽题
/// ===============================================================================================================================================================

class Drag extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String headlineContent;
  String description;
  String attachment;
  Drag({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.headlineContent,
    required this.description,
    required this.attachment,
  });

  @override
  State<Drag> createState() => DragState();
}

class DragState extends State<Drag> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: const Center(child: Text('Drag', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget(context);
  }
}

/// 连线题
/// ===============================================================================================================================================================

class Connection extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String headlineContent;
  String description;
  String attachment;
  Connection({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.headlineContent,
    required this.description,
    required this.attachment,
  });

  @override
  State<Connection> createState() => ConnectionState();
}

class ConnectionState extends State<Connection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: const Center(child: Text('Connection', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget(context);
  }
}
