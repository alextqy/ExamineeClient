import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/public/lang.dart';
import 'package:client/public/tools.dart';
import 'package:client/Views/common/show_alert_dialog.dart';
import 'package:client/Views/common/basic_info.dart';
import 'package:client/Views/common/test_questions.dart';

import 'package:client/providers/base_notifier.dart';
import 'package:client/providers/examinee_token_notifier.dart';

import 'package:client/models/scantron_model.dart';

// ignore: must_be_immutable
class TestPaper extends StatefulWidget {
  int seconds = 0;
  late TimerHandler timerHandler;
  TestPaper({super.key, required this.seconds}) {
    timerHandler = TimerHandler(seconds: seconds);
  }

  @override
  State<TestPaper> createState() => TestPaperState();
}

class TestPaperState extends State<TestPaper> {
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();
  ScrollController listViewController = ScrollController();
  int currentItemID = 0;
  double currentListOffset = 0;

  bool multipleChoiceShow = false;
  bool judgmentQuestionsShow = false;
  bool multipleSelectionShow = false;
  bool fillInTheBlanksShow = false;
  bool quizQuestionsShow = false;
  bool codeTestingShow = false;
  bool dragShow = false;
  bool connectionShow = false;

  int currentID = 0;
  int currentQuestionType = 0;
  String currentQuestionTitle = '';
  double currentScore = 0;
  String currentHeadlineContent = '';
  String currentDescription = '';
  String currentAttachment = '';

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
          questionContext();
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
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          Container(height: 1.0, color: Colors.grey),
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
          Container(height: 1.0, color: Colors.grey),
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
                    child: Text(Lang().exit, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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

  // 试题类型 1单选 2判断 3多选 4填空 5问答 6代码实训 7拖拽 8连线
  showQuestion(int questionType) {
    switch (questionType) {
      case 1:
        multipleChoiceShow = true;
        judgmentQuestionsShow = false;
        multipleSelectionShow = false;
        fillInTheBlanksShow = false;
        quizQuestionsShow = false;
        codeTestingShow = false;
        dragShow = false;
        connectionShow = false;
        break;
      case 2:
        multipleChoiceShow = false;
        judgmentQuestionsShow = true;
        multipleSelectionShow = false;
        fillInTheBlanksShow = false;
        quizQuestionsShow = false;
        codeTestingShow = false;
        dragShow = false;
        connectionShow = false;
        break;
      case 3:
        multipleChoiceShow = false;
        judgmentQuestionsShow = false;
        multipleSelectionShow = true;
        fillInTheBlanksShow = false;
        quizQuestionsShow = false;
        codeTestingShow = false;
        dragShow = false;
        connectionShow = false;
        break;
      case 4:
        multipleChoiceShow = false;
        judgmentQuestionsShow = false;
        multipleSelectionShow = false;
        fillInTheBlanksShow = true;
        quizQuestionsShow = false;
        codeTestingShow = false;
        dragShow = false;
        connectionShow = false;
        break;
      case 5:
        multipleChoiceShow = false;
        judgmentQuestionsShow = false;
        multipleSelectionShow = false;
        fillInTheBlanksShow = false;
        quizQuestionsShow = true;
        codeTestingShow = false;
        dragShow = false;
        connectionShow = false;
        break;
      case 6:
        multipleChoiceShow = false;
        judgmentQuestionsShow = false;
        multipleSelectionShow = false;
        fillInTheBlanksShow = false;
        quizQuestionsShow = false;
        codeTestingShow = true;
        dragShow = false;
        connectionShow = false;
        break;
      case 7:
        multipleChoiceShow = false;
        judgmentQuestionsShow = false;
        multipleSelectionShow = false;
        fillInTheBlanksShow = false;
        quizQuestionsShow = false;
        codeTestingShow = false;
        dragShow = true;
        connectionShow = false;
        break;
      case 8:
        multipleChoiceShow = false;
        judgmentQuestionsShow = false;
        multipleSelectionShow = false;
        fillInTheBlanksShow = false;
        quizQuestionsShow = false;
        codeTestingShow = false;
        dragShow = false;
        connectionShow = true;
        break;
      default:
        break;
    }
  }

  // 试题详情
  questionContext() {
    if (currentItemID > 0) {
      currentID = examineeTokenNotifier.scantronListModel[currentItemID].id;
      currentQuestionType = examineeTokenNotifier.scantronListModel[currentItemID].questionType;
      currentQuestionTitle = examineeTokenNotifier.scantronListModel[currentItemID].questionTitle;
      currentScore = examineeTokenNotifier.scantronListModel[currentItemID].score;
      currentHeadlineContent = examineeTokenNotifier.scantronListModel[currentItemID].headlineContent;
      currentDescription = examineeTokenNotifier.scantronListModel[currentItemID].description;
      currentAttachment = examineeTokenNotifier.scantronListModel[currentItemID].attachment;
      setState(() {
        showQuestion(currentQuestionType);
      });
    }
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
        child: Column(
          children: [
            /// header
            /*
            SizedBox(
              width: double.infinity,
              height: 30,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                child: const Row(
                  children: [],
                ),
              ),
            ),
            */

            /// body
            Expanded(
              child: Row(
                children: [
                  Tooltip(
                    decoration: const BoxDecoration(color: Colors.transparent),
                    textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    message: Lang().previous,
                    child: SizedBox(
                      width: 50,
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              if (currentItemID > 0) {
                                currentItemID -= 1;
                                currentListOffset = currentItemID * 30;
                                questionContext();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: ShapeDecoration(shape: Border.all(width: 0, color: Colors.transparent)),
                      padding: const EdgeInsets.all(30),
                      margin: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Visibility(
                            visible: multipleChoiceShow,
                            child: MultipleChoice(
                              id: currentID,
                              questionTitle: currentQuestionTitle,
                              score: currentScore,
                              headlineContent: currentHeadlineContent,
                              description: currentDescription,
                              attachment: currentAttachment,
                            ),
                          ),
                          Visibility(
                            visible: judgmentQuestionsShow,
                            child: JudgmentQuestions(
                              id: currentID,
                              questionTitle: currentQuestionTitle,
                              score: currentScore,
                              headlineContent: currentHeadlineContent,
                              description: currentDescription,
                              attachment: currentAttachment,
                            ),
                          ),
                          Visibility(
                            visible: multipleSelectionShow,
                            child: MultipleSelection(
                              id: currentID,
                              questionTitle: currentQuestionTitle,
                              score: currentScore,
                              headlineContent: currentHeadlineContent,
                              description: currentDescription,
                              attachment: currentAttachment,
                            ),
                          ),
                          Visibility(
                            visible: fillInTheBlanksShow,
                            child: FillInTheBlanks(
                              id: currentID,
                              questionTitle: currentQuestionTitle,
                              score: currentScore,
                              headlineContent: currentHeadlineContent,
                              description: currentDescription,
                              attachment: currentAttachment,
                            ),
                          ),
                          Visibility(
                            visible: quizQuestionsShow,
                            child: QuizQuestions(
                              id: currentID,
                              questionTitle: currentQuestionTitle,
                              score: currentScore,
                              headlineContent: currentHeadlineContent,
                              description: currentDescription,
                              attachment: currentAttachment,
                            ),
                          ),
                          Visibility(
                            visible: codeTestingShow,
                            child: CodeTesting(
                              id: currentID,
                              questionTitle: currentQuestionTitle,
                              score: currentScore,
                              headlineContent: currentHeadlineContent,
                              description: currentDescription,
                              attachment: currentAttachment,
                            ),
                          ),
                          Visibility(
                            visible: dragShow,
                            child: Drag(
                              id: currentID,
                              questionTitle: currentQuestionTitle,
                              score: currentScore,
                              headlineContent: currentHeadlineContent,
                              description: currentDescription,
                              attachment: currentAttachment,
                            ),
                          ),
                          Visibility(
                            visible: connectionShow,
                            child: Connection(
                              id: currentID,
                              questionTitle: currentQuestionTitle,
                              score: currentScore,
                              headlineContent: currentHeadlineContent,
                              description: currentDescription,
                              attachment: currentAttachment,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tooltip(
                    decoration: const BoxDecoration(color: Colors.transparent),
                    textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    message: Lang().next,
                    child: SizedBox(
                      width: 50,
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_outlined, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              if (currentItemID < examineeTokenNotifier.scantronListModel.length - 1) {
                                currentItemID += 1;
                                currentListOffset = currentItemID * 30;
                                questionContext();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 5.0, color: Colors.transparent),

            /// footer
            SizedBox(
              width: double.infinity,
              height: 30,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                child: Row(children: [
                  const Expanded(child: SizedBox()),
                  widget.timerHandler,
                  const Expanded(child: SizedBox()),
                ]),
              ),
            ),
          ],
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
