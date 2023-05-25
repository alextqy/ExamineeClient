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

  bool titleShow = false;
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
  String currentDescription = '';
  String currentAttachment = '';
  String currentLanguage = '';
  String currentLanguageVersion = '';

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
      case 0:
        titleShow = true;
        multipleChoiceShow = false;
        judgmentQuestionsShow = false;
        multipleSelectionShow = false;
        fillInTheBlanksShow = false;
        quizQuestionsShow = false;
        codeTestingShow = false;
        dragShow = false;
        connectionShow = false;
        break;
      case 1:
        titleShow = false;
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
        titleShow = false;
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
        titleShow = false;
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
        titleShow = false;
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
        titleShow = false;
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
        titleShow = false;
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
        titleShow = false;
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
        titleShow = false;
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
    setState(() {
      int id = examineeTokenNotifier.scantronListModel[currentItemID].id;
      int questionType = examineeTokenNotifier.scantronListModel[currentItemID].questionType;
      String questionTitle = examineeTokenNotifier.scantronListModel[currentItemID].questionTitle;
      double score = examineeTokenNotifier.scantronListModel[currentItemID].score;
      String headlineContent = examineeTokenNotifier.scantronListModel[currentItemID].headlineContent;
      String description = examineeTokenNotifier.scantronListModel[currentItemID].description;
      String attachment = examineeTokenNotifier.scantronListModel[currentItemID].attachment;
      String language = examineeTokenNotifier.scantronListModel[currentItemID].language;
      String languageVersion = examineeTokenNotifier.scantronListModel[currentItemID].languageVersion;

      currentID = id;
      currentQuestionType = questionType > 0 ? questionType : 0;
      currentQuestionTitle = questionTitle.isEmpty || questionTitle == 'none' ? headlineContent : questionTitle;
      currentScore = score > 0 ? score : 0;
      currentDescription = description.isEmpty || description == 'none' ? '' : description;
      currentAttachment = attachment.isEmpty || attachment == 'none' ? '' : attachment;
      currentLanguage = language.isEmpty || language == 'none' ? '' : language;
      currentLanguageVersion = languageVersion.isEmpty || languageVersion == 'none' ? '' : languageVersion;
      showQuestion(currentQuestionType);
    });
  }

  Widget checkQuestionWidget() {
    if (titleShow == true) {
      return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: Headline(
          id: currentID,
          questionTitle: currentQuestionTitle,
          score: currentScore,
          description: currentDescription,
          attachment: currentAttachment,
        ),
      );
    } else if (multipleChoiceShow == true) {
      return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: MultipleChoice(
          id: currentID,
          questionTitle: currentQuestionTitle,
          score: currentScore,
          description: currentDescription,
          attachment: currentAttachment,
        ),
      );
    } else if (judgmentQuestionsShow == true) {
      return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: JudgmentQuestions(
          id: currentID,
          questionTitle: currentQuestionTitle,
          score: currentScore,
          description: currentDescription,
          attachment: currentAttachment,
        ),
      );
    } else if (multipleSelectionShow == true) {
      return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: MultipleSelection(
          id: currentID,
          questionTitle: currentQuestionTitle,
          score: currentScore,
          description: currentDescription,
          attachment: currentAttachment,
        ),
      );
    } else if (fillInTheBlanksShow == true) {
      return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: FillInTheBlanks(
          id: currentID,
          questionTitle: currentQuestionTitle,
          score: currentScore,
          description: currentDescription,
          attachment: currentAttachment,
        ),
      );
    } else if (quizQuestionsShow == true) {
      return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: QuizQuestions(
          id: currentID,
          questionTitle: currentQuestionTitle,
          score: currentScore,
          description: currentDescription,
          attachment: currentAttachment,
        ),
      );
    } else if (codeTestingShow == true) {
      return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: CodeTesting(
          id: currentID,
          questionTitle: currentQuestionTitle,
          score: currentScore,
          description: currentDescription,
          attachment: currentAttachment,
          language: currentLanguage,
          languageVersion: currentLanguageVersion,
        ),
      );
    } else if (dragShow == true) {
      return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: Drag(
          id: currentID,
          questionTitle: currentQuestionTitle,
          score: currentScore,
          description: currentDescription,
          attachment: currentAttachment,
        ),
      );
    } else if (connectionShow == true) {
      return Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: Connection(
          id: currentID,
          questionTitle: currentQuestionTitle,
          score: currentScore,
          description: currentDescription,
          attachment: currentAttachment,
        ),
      );
    } else {
      return Container();
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
                      padding: const EdgeInsets.all(45),
                      margin: const EdgeInsets.all(0),
                      child: checkQuestionWidget(),
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
