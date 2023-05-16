// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:client/models/scantron_solution_model.dart';
// import 'package:client/providers/base_notifier.dart';
import 'package:client/providers/examinee_token_notifier.dart';
import 'package:client/Views/common/basic_info.dart';
import 'package:client/Views/common/show_alert_dialog.dart';
import 'package:client/public/lang.dart';
import 'package:client/public/tools.dart';

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
  TextEditingController optionController = TextEditingController();
  TextEditingController questionTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void fetchData() {
    examineeTokenNotifier.examScantronSolutionInfo(id: widget.id).then((value) {
      setState(() {
        examineeTokenNotifier.scantronSolutionListModel = ScantronSolutionModel().fromJsonList(jsonEncode(value.data));
      });
    });
  }

  List<Widget> generateList() {
    List<Widget> optionList = [];
    if (examineeTokenNotifier.scantronSolutionListModel.isNotEmpty) {
      for (var element in examineeTokenNotifier.scantronSolutionListModel) {
        optionList.add(
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(currentOptionID == element.id || element.candidateAnswer == 'True' ? Icons.radio_button_checked_outlined : Icons.radio_button_unchecked_outlined, size: 15, color: Colors.black),
                const SizedBox(width: 10),
                InkWell(
                  child: SizedBox(
                    width: 800,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                      element.option,
                    ),
                  ),
                  onTap: () {
                    examineeTokenNotifier.examAnswer(scantronID: widget.id, id: element.id, answer: '').then((value) {
                      setState(() {
                        currentOptionID == element.id;
                        fetchData();
                      });
                    });
                  },
                ),
                const Expanded(child: SizedBox()),
                Tooltip(
                  message: Lang().details,
                  verticalOffset: 10,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.info_outline_rounded),
                    color: Colors.black,
                    onPressed: () {
                      optionController.text = element.option;
                      setState(() {
                        alertDialog(
                          context,
                          w: 800,
                          h: 300,
                          widget: Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextField(
                              controller: optionController,
                              maxLines: null,
                              readOnly: true,
                              decoration: const InputDecoration(border: InputBorder.none),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Tooltip(
                  message: Lang().attachments,
                  verticalOffset: 10,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.image_outlined),
                    color: Colors.black,
                    onPressed: () {
                      examineeTokenNotifier.examScantronSolutionViewAttachments(filePath: element.optionAttachment).then((value) {
                        if (value.data == null) {
                          showSnackBar(context, content: Lang().noData);
                        } else {
                          setState(() {
                            alertDialog(
                              context,
                              w: 800,
                              h: 400,
                              widget: scrollbarWidget(Image.memory(Tools().byteListToBytes(Tools().toByteList(value.data)))),
                            );
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return optionList;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    questionTitleController.text = '(${widget.score} ${Lang().points})  ${widget.questionTitle}';
    descriptionController.text = widget.description == '' ? '' : '${Lang().describe}: ${widget.description}';
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Center(
            child: SizedBox(
              height: 80,
              width: 1350,
              child: TextField(
                controller: questionTitleController,
                maxLines: null,
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            width: 1350,
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  child: Text(Lang().attachments),
                  onPressed: () {
                    examineeTokenNotifier.examScantronSolutionViewAttachments(filePath: widget.attachment).then((value) {
                      if (value.data == null) {
                        showSnackBar(context, content: Lang().noData);
                      } else {
                        setState(() {
                          alertDialog(
                            context,
                            w: 800,
                            h: 400,
                            widget: scrollbarWidget(
                              Image.memory(Tools().byteListToBytes(Tools().toByteList(value.data))),
                            ),
                          );
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 60,
              width: 1350,
              child: TextField(
                controller: descriptionController,
                maxLines: null,
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 260,
              width: 1350,
              child: ListView(
                children: generateList(),
              ),
            ),
          ),
        ],
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
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();
  int currentOptionID = 0;
  TextEditingController optionController = TextEditingController();
  TextEditingController questionTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void fetchData() {
    examineeTokenNotifier.examScantronSolutionInfo(id: widget.id).then((value) {
      setState(() {
        examineeTokenNotifier.scantronSolutionListModel = ScantronSolutionModel().fromJsonList(jsonEncode(value.data));
      });
    });
  }

  List<Widget> generateList() {
    List<Widget> optionList = [];
    if (examineeTokenNotifier.scantronSolutionListModel.isNotEmpty) {
      for (var element in examineeTokenNotifier.scantronSolutionListModel) {
        optionList.add(
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(currentOptionID == element.id || element.candidateAnswer == 'True' ? Icons.radio_button_checked_outlined : Icons.radio_button_unchecked_outlined, size: 15, color: Colors.black),
                const SizedBox(width: 10),
                InkWell(
                  child: SizedBox(
                    width: 800,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                      element.option,
                    ),
                  ),
                  onTap: () {
                    examineeTokenNotifier.examAnswer(scantronID: widget.id, id: element.id, answer: '').then((value) {
                      setState(() {
                        currentOptionID == element.id;
                        fetchData();
                      });
                    });
                  },
                ),
                const Expanded(child: SizedBox()),
                Tooltip(
                  message: Lang().details,
                  verticalOffset: 10,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.info_outline_rounded),
                    color: Colors.black,
                    onPressed: () {
                      optionController.text = element.option;
                      setState(() {
                        alertDialog(
                          context,
                          w: 800,
                          h: 300,
                          widget: Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextField(
                              controller: optionController,
                              maxLines: null,
                              readOnly: true,
                              decoration: const InputDecoration(border: InputBorder.none),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Tooltip(
                  message: Lang().attachments,
                  verticalOffset: 10,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.image_outlined),
                    color: Colors.black,
                    onPressed: () {
                      examineeTokenNotifier.examScantronSolutionViewAttachments(filePath: element.optionAttachment).then((value) {
                        if (value.data == null) {
                          showSnackBar(context, content: Lang().noData);
                        } else {
                          setState(() {
                            alertDialog(
                              context,
                              w: 800,
                              h: 400,
                              widget: scrollbarWidget(Image.memory(Tools().byteListToBytes(Tools().toByteList(value.data)))),
                            );
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return optionList;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    questionTitleController.text = '(${widget.score} ${Lang().points})  ${widget.questionTitle}';
    descriptionController.text = widget.description == '' ? '' : '${Lang().describe}: ${widget.description}';
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Center(
            child: SizedBox(
              height: 80,
              width: 1350,
              child: TextField(
                controller: questionTitleController,
                maxLines: null,
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            width: 1350,
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  child: Text(Lang().attachments),
                  onPressed: () {
                    examineeTokenNotifier.examScantronSolutionViewAttachments(filePath: widget.attachment).then((value) {
                      if (value.data == null) {
                        showSnackBar(context, content: Lang().noData);
                      } else {
                        setState(() {
                          alertDialog(
                            context,
                            w: 800,
                            h: 400,
                            widget: scrollbarWidget(
                              Image.memory(Tools().byteListToBytes(Tools().toByteList(value.data))),
                            ),
                          );
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 60,
              width: 1350,
              child: TextField(
                controller: descriptionController,
                maxLines: null,
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 260,
              width: 1350,
              child: ListView(
                children: generateList(),
              ),
            ),
          ),
        ],
      ),
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
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();
  int currentOptionID = 0;
  TextEditingController optionController = TextEditingController();
  TextEditingController questionTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void fetchData() {
    examineeTokenNotifier.examScantronSolutionInfo(id: widget.id).then((value) {
      setState(() {
        examineeTokenNotifier.scantronSolutionListModel = ScantronSolutionModel().fromJsonList(jsonEncode(value.data));
      });
    });
  }

  List<Widget> generateList() {
    List<Widget> optionList = [];
    if (examineeTokenNotifier.scantronSolutionListModel.isNotEmpty) {
      for (var element in examineeTokenNotifier.scantronSolutionListModel) {
        optionList.add(
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(currentOptionID == element.id || element.candidateAnswer == 'True' ? Icons.radio_button_checked_outlined : Icons.radio_button_unchecked_outlined, size: 15, color: Colors.black),
                const SizedBox(width: 10),
                InkWell(
                  child: SizedBox(
                    width: 800,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                      element.option,
                    ),
                  ),
                  onTap: () {
                    examineeTokenNotifier.examAnswer(scantronID: widget.id, id: element.id, answer: '').then((value) {
                      setState(() {
                        currentOptionID == element.id;
                        fetchData();
                      });
                    });
                  },
                ),
                const Expanded(child: SizedBox()),
                Tooltip(
                  message: Lang().details,
                  verticalOffset: 10,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.info_outline_rounded),
                    color: Colors.black,
                    onPressed: () {
                      optionController.text = element.option;
                      setState(() {
                        alertDialog(
                          context,
                          w: 800,
                          h: 300,
                          widget: Padding(
                            padding: const EdgeInsets.all(0),
                            child: TextField(
                              controller: optionController,
                              maxLines: null,
                              readOnly: true,
                              decoration: const InputDecoration(border: InputBorder.none),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Tooltip(
                  message: Lang().attachments,
                  verticalOffset: 10,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.image_outlined),
                    color: Colors.black,
                    onPressed: () {
                      examineeTokenNotifier.examScantronSolutionViewAttachments(filePath: element.optionAttachment).then((value) {
                        if (value.data == null) {
                          showSnackBar(context, content: Lang().noData);
                        } else {
                          setState(() {
                            alertDialog(
                              context,
                              w: 800,
                              h: 400,
                              widget: scrollbarWidget(Image.memory(Tools().byteListToBytes(Tools().toByteList(value.data)))),
                            );
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return optionList;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    questionTitleController.text = '(${widget.score} ${Lang().points})  ${widget.questionTitle}';
    descriptionController.text = widget.description == '' ? '' : '${Lang().describe}: ${widget.description}';
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Center(
            child: SizedBox(
              height: 80,
              width: 1350,
              child: TextField(
                controller: questionTitleController,
                maxLines: null,
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            width: 1350,
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  child: Text(Lang().attachments),
                  onPressed: () {
                    examineeTokenNotifier.examScantronSolutionViewAttachments(filePath: widget.attachment).then((value) {
                      if (value.data == null) {
                        showSnackBar(context, content: Lang().noData);
                      } else {
                        setState(() {
                          alertDialog(
                            context,
                            w: 800,
                            h: 400,
                            widget: scrollbarWidget(
                              Image.memory(Tools().byteListToBytes(Tools().toByteList(value.data))),
                            ),
                          );
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 60,
              width: 1350,
              child: TextField(
                controller: descriptionController,
                maxLines: null,
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 260,
              width: 1350,
              child: ListView(
                children: generateList(),
              ),
            ),
          ),
        ],
      ),
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
