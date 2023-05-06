// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:client/models/scantron_solution_model.dart';
import 'package:client/providers/examinee_token_notifier.dart';
// import 'package:client/Views/common/basic_info.dart';

/// 大标题
/// ===============================================================================================================================================================

class Headline extends StatefulWidget {
  int id;
  String questionTitle;
  double score;

  String description;
  String attachment;
  Headline({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.description,
    required this.attachment,
  });

  @override
  State<Headline> createState() => HeadlineState();
}

class HeadlineState extends State<Headline> {
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
      child: Center(child: Text(widget.questionTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget(context);
  }
}

/// 单选
/// ===============================================================================================================================================================

class MultipleChoice extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String description;
  String attachment;
  MultipleChoice({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.description,
    required this.attachment,
  });

  @override
  State<MultipleChoice> createState() => MultipleChoiceState();
}

class MultipleChoiceState extends State<MultipleChoice> {
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();
  int currentOptionID = 0;

  void fetchData() {
    examineeTokenNotifier.examScantronSolutionInfo(id: widget.id).then((value) {
      setState(() {
        examineeTokenNotifier.scantronSolutionListModel = ScantronSolutionModel().fromJsonList(jsonEncode(value.data));
      });
    });
  }

  List<Widget> generateList() {
    List<Widget> listTileWidget = [];
    if (examineeTokenNotifier.scantronSolutionListModel.isNotEmpty) {
      for (ScantronSolutionModel element in examineeTokenNotifier.scantronSolutionListModel) {
        listTileWidget.add(
          Row(
            children: [
              SizedBox(
                height: 45,
                child: Text(
                  element.option,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
        );
      }
    }
    return listTileWidget;
    // List<ListTile> listTileWidget = [];
    // List<Container> optionList = [];
    // if (examineeTokenNotifier.scantronSolutionListModel.isNotEmpty) {
    //   for (var element in examineeTokenNotifier.scantronSolutionListModel) {
    /*
        optionList.add(
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                Icon(currentOptionID == element.id ? Icons.radio_button_checked_outlined : Icons.radio_button_unchecked_outlined, size: 15, color: Colors.black),
                const SizedBox(width: 10),
                InkWell(
                  child: SizedBox(
                    width: 950,
                    height: 100,
                    child: scrollbarWidget(
                      Text('sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点sadfasdf12312321fsadfasdf发射点发生大撒旦发射点', maxLines: 1, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      currentOptionID = element.id;
                    });
                  },
                ),
              ],
            ),
          ),
        );
        */
    //   }
    // }
    // return optionList;
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
                Text(widget.questionTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(widget.description, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 30),
            // Expanded(
            //   child: ListView(
            //     shrinkWrap: true,
            //     padding: const EdgeInsets.all(0),
            //     children: generateList(),
            //   ),
            // )
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

  String description;
  String attachment;
  JudgmentQuestions({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
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

  String description;
  String attachment;
  MultipleSelection({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
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

  String description;
  String attachment;
  FillInTheBlanks({
    required this.id,
    super.key,
    required this.questionTitle,
    required this.score,
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

  String description;
  String attachment;
  QuizQuestions({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
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

  String description;
  String attachment;
  CodeTesting({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
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

  String description;
  String attachment;
  Drag({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
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

  String description;
  String attachment;
  Connection({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
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
