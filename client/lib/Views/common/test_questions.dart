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
  TextEditingController questionTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    questionTitleController.text = widget.questionTitle;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          SizedBox(
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
        ],
      ),
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
      for (ScantronSolutionModel element in examineeTokenNotifier.scantronSolutionListModel) {
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
                        if (value.state == true) {
                          currentOptionID == element.id;
                          fetchData();
                        } else {
                          showSnackBar(context, content: Lang().operationFailed);
                        }
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
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    questionTitleController.text = '(${widget.score} ${Lang().points})  ${widget.questionTitle}';
    descriptionController.text = widget.description == '' ? '' : '${Lang().describe}: ${widget.description}';
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
          const SizedBox(height: 5),
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
          const SizedBox(height: 5),
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
      for (ScantronSolutionModel element in examineeTokenNotifier.scantronSolutionListModel) {
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
                        if (value.state == true) {
                          currentOptionID == element.id;
                          fetchData();
                        } else {
                          showSnackBar(context, content: Lang().operationFailed);
                        }
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
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    questionTitleController.text = '(${widget.score} ${Lang().points})  ${widget.questionTitle}';
    descriptionController.text = widget.description == '' ? '' : '${Lang().describe}: ${widget.description}';
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
          const SizedBox(height: 5),
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
          const SizedBox(height: 5),
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
      for (ScantronSolutionModel element in examineeTokenNotifier.scantronSolutionListModel) {
        optionList.add(
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(element.candidateAnswer == 'True' ? Icons.check : Icons.check_box_outline_blank_outlined, size: 15, color: Colors.black),
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
                    String answerCheck = 'check';
                    if (element.candidateAnswer == 'True') {
                      answerCheck = '';
                    }
                    examineeTokenNotifier.examAnswer(scantronID: widget.id, id: element.id, answer: answerCheck).then((value) {
                      setState(() {
                        if (value.state == true) {
                          fetchData();
                        } else {
                          showSnackBar(context, content: Lang().operationFailed);
                        }
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
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    questionTitleController.text = '(${widget.score} ${Lang().points})  ${widget.questionTitle}';
    descriptionController.text = widget.description == '' ? '' : '${Lang().describe}: ${widget.description}';
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
          const SizedBox(height: 5),
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
          const SizedBox(height: 5),
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
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();
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
      for (ScantronSolutionModel element in examineeTokenNotifier.scantronSolutionListModel) {
        TextEditingController inputController = TextEditingController();
        inputController.text = element.candidateAnswer;
        optionList.add(
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: inputController,
              style: const TextStyle(color: Colors.black, fontSize: 20),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: Lang().inputContent,
                hintStyle: const TextStyle(color: Colors.grey),
                hintMaxLines: 1,
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                suffixIcon: Tooltip(
                  message: Lang().submit,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.send_sharp, color: Colors.black, size: 20),
                    onPressed: () {
                      if (inputController.text.isNotEmpty && inputController.text != element.candidateAnswer) {
                        examineeTokenNotifier.examAnswer(scantronID: widget.id, id: element.id, answer: inputController.text).then((value) {
                          if (value.state == true) {
                            showSnackBar(context, content: Lang().operationComplete);
                          } else {
                            showSnackBar(context, content: Lang().operationFailed);
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return optionList;
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    questionTitleController.text = '(${widget.score} ${Lang().points})  ${widget.questionTitle.replaceAll('<->', ' [ ] ')}';
    descriptionController.text = widget.description == '' ? '' : '${Lang().describe}: ${widget.description}';
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
          const SizedBox(height: 5),
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
          const SizedBox(height: 5),
          Center(
            child: SizedBox(
              height: 260,
              width: 500,
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
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();
  TextEditingController questionTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController inputController = TextEditingController();

  void fetchData() {
    examineeTokenNotifier.examScantronSolutionInfo(id: widget.id).then((value) {
      setState(() {
        examineeTokenNotifier.scantronSolutionListModel = ScantronSolutionModel().fromJsonList(jsonEncode(value.data));
        if (examineeTokenNotifier.scantronSolutionListModel[0].candidateAnswer.isNotEmpty) {
          inputController.text = examineeTokenNotifier.scantronSolutionListModel[0].candidateAnswer;
        } else {
          inputController.text = '';
        }
      });
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainWidget(BuildContext context) {
    questionTitleController.text = '(${widget.score} ${Lang().points})  ${widget.questionTitle}';
    descriptionController.text = widget.description == '' ? '' : '${Lang().describe}: ${widget.description}';
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
          const SizedBox(height: 5),
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
          const SizedBox(height: 5),
          Center(
            child: Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: TextField(
                minLines: 9,
                maxLines: 9,
                controller: inputController,
                style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: Lang().inputContent,
                  hintStyle: const TextStyle(color: Colors.grey),
                  hintMaxLines: 1,
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  suffixIcon: Tooltip(
                    message: Lang().submit,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                    child: IconButton(
                      iconSize: 20,
                      icon: const Icon(Icons.send_sharp, color: Colors.black),
                      onPressed: () {
                        if (examineeTokenNotifier.scantronSolutionListModel.isNotEmpty) {
                          int id = examineeTokenNotifier.scantronSolutionListModel[0].id;
                          String candidateAnswer = examineeTokenNotifier.scantronSolutionListModel[0].candidateAnswer;
                          if (inputController.text.isNotEmpty && inputController.text != candidateAnswer) {
                            examineeTokenNotifier.examAnswer(scantronID: widget.id, id: id, answer: inputController.text).then((value) {
                              if (value.state == true) {
                                fetchData();
                                showSnackBar(context, content: Lang().operationComplete);
                              } else {
                                showSnackBar(context, content: Lang().operationFailed);
                              }
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
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

/// 代码测试
/// ===============================================================================================================================================================

class CodeTesting extends StatefulWidget {
  int id;
  String questionTitle;
  double score;
  String description;
  String attachment;
  String language;
  String languageVersion;
  CodeTesting({
    super.key,
    required this.id,
    required this.questionTitle,
    required this.score,
    required this.description,
    required this.attachment,
    required this.language,
    required this.languageVersion,
  });

  @override
  State<CodeTesting> createState() => CodeTestingState();
}

class CodeTestingState extends State<CodeTesting> {
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();
  TextEditingController questionTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController inputController = TextEditingController();
  bool testStatus = true;

  void fetchData() {
    examineeTokenNotifier.examScantronSolutionInfo(id: widget.id).then((value) {
      setState(() {
        examineeTokenNotifier.scantronSolutionListModel = ScantronSolutionModel().fromJsonList(jsonEncode(value.data));
        if (examineeTokenNotifier.scantronSolutionListModel.isNotEmpty) {
          inputController.text = examineeTokenNotifier.scantronSolutionListModel[0].candidateAnswer;
        } else {
          inputController.text = '';
        }
      });
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget langFunctionContentHeader() {
    bool cLangShow = false;
    bool javaLangShow = false;
    bool jsLangShow = false;
    bool phpLangShow = false;
    bool pyLangShow = false;

    if (widget.language == 'c') {
      cLangShow = true;
    }
    if (widget.language == 'java') {
      javaLangShow = true;
    }
    if (widget.language == 'javascript') {
      jsLangShow = true;
    }
    if (widget.language == 'php') {
      phpLangShow = true;
    }
    if (widget.language == 'python') {
      pyLangShow = true;
    }

    return SizedBox(
      width: 1350,
      child: Column(
        children: [
          Visibility(
            visible: cLangShow,
            child: const Column(children: [Text('')]),
          ),
          Visibility(
            visible: javaLangShow,
            child: const Column(
              children: [
                Row(children: [Text('public static String func() {', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))])
              ],
            ),
          ),
          Visibility(
            visible: jsLangShow,
            child: const Column(
              children: [
                Row(children: [Text('function main() {', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
                Row(children: [Text('    try {', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          Visibility(
            visible: phpLangShow,
            child: const Column(
              children: [
                Row(children: [Text('function Run(){', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
                Row(children: [Text('    try {', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          Visibility(
            visible: pyLangShow,
            child: const Column(
              children: [
                Row(children: [Text('def Run():', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
                Row(children: [Text('    try:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget langFunctionContentFooter() {
    bool cLangShow = false;
    bool javaLangShow = false;
    bool jsLangShow = false;
    bool phpLangShow = false;
    bool pyLangShow = false;

    if (widget.language == 'c') {
      cLangShow = true;
    }
    if (widget.language == 'java') {
      javaLangShow = true;
    }
    if (widget.language == 'javascript') {
      jsLangShow = true;
    }
    if (widget.language == 'php') {
      phpLangShow = true;
    }
    if (widget.language == 'python') {
      pyLangShow = true;
    }

    return SizedBox(
      width: 1350,
      child: Column(
        children: [
          Visibility(
            visible: cLangShow,
            child: const Column(children: [Text('')]),
          ),
          Visibility(
            visible: javaLangShow,
            child: const Column(
              children: [
                Row(children: [Text('}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          Visibility(
            visible: jsLangShow,
            child: const Column(
              children: [
                Row(children: [Text('    }', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
                Row(children: [Text('}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          Visibility(
            visible: phpLangShow,
            child: const Column(
              children: [
                Row(children: [Text('    } catch (Exception \$e) {', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
                Row(children: [Text('        return \$e->getMessage();', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
                Row(children: [Text('    }', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
                Row(children: [Text('}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          Visibility(
            visible: pyLangShow,
            child: const Column(
              children: [
                Row(children: [Text('    except Exception as e:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
                Row(children: [Text('        return format(e)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mainWidget(BuildContext context) {
    questionTitleController.text = '(${widget.score} ${Lang().points})  ${widget.questionTitle}';
    descriptionController.text = widget.description == '' ? '' : '${Lang().describe}: ${widget.description}';
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
          Center(
            child: SizedBox(
              height: 45,
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
          langFunctionContentHeader(),
          SizedBox(
            height: 120,
            width: 1350,
            child: Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: TextField(
                minLines: 9,
                maxLines: 9,
                controller: inputController,
                style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: Lang().inputContent,
                  hintStyle: const TextStyle(color: Colors.grey),
                  hintMaxLines: 1,
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  suffixIcon: Column(
                    children: [
                      Tooltip(
                        message: Lang().test,
                        decoration: const BoxDecoration(color: Colors.transparent),
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        child: IconButton(
                          iconSize: 20,
                          icon: const Icon(Icons.title_outlined, color: Colors.black),
                          onPressed: () {
                            if (testStatus == true && inputController.text.isNotEmpty) {
                              testStatus = false;
                              examineeTokenNotifier.codeExecTest(language: widget.language, version: widget.languageVersion, codeStr: inputController.text).then((value) {
                                if (value.state == true) {
                                  showSnackBar(context, content: value.data);
                                } else {
                                  showSnackBar(context, content: value.memo);
                                }
                                testStatus = true;
                              });
                            }
                          },
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Tooltip(
                        message: Lang().submit,
                        decoration: const BoxDecoration(color: Colors.transparent),
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        child: IconButton(
                          iconSize: 20,
                          icon: const Icon(Icons.send_sharp, color: Colors.black),
                          onPressed: () {
                            if (examineeTokenNotifier.scantronSolutionListModel.isNotEmpty) {
                              int id = examineeTokenNotifier.scantronSolutionListModel[0].id;
                              String candidateAnswer = examineeTokenNotifier.scantronSolutionListModel[0].candidateAnswer;
                              if (inputController.text.isNotEmpty && inputController.text != candidateAnswer) {
                                examineeTokenNotifier.examAnswer(scantronID: widget.id, id: id, answer: inputController.text).then((value) {
                                  if (value.state == true) {
                                    fetchData();
                                    showSnackBar(context, content: Lang().operationComplete);
                                  } else {
                                    showSnackBar(context, content: Lang().operationFailed);
                                  }
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          langFunctionContentFooter()
        ],
      ),
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
