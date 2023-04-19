import 'dart:convert';

import 'package:client/models/examinfo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/public/lang.dart';
import 'package:client/Views/common/black_white.dart';
import 'package:client/public/file.dart';
import 'package:client/Views/common/show_alert_dialog.dart';
import 'package:client/public/tools.dart';

import 'package:client/providers/base_notifier.dart';
import 'package:client/providers/examinee_token_notifier.dart';

enum Labelem { midgrey, viridian, cerulean }

void main() {
  if (FileHelper().jsonRead(key: 'lang') == '') {
    FileHelper().jsonWrite(key: 'lang', value: 'en');
  }
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: black,
      ),
      home: const Scaffold(body: Entrance()),
    ),
  );
}

class Entrance extends StatefulWidget {
  const Entrance({super.key});

  @override
  State<Entrance> createState() => EntranceState();
}

class EntranceState extends State<Entrance> {
  ExamineeTokenNotifier examineeTokenNotifier = ExamineeTokenNotifier();

  Map<Labelem, Color> labelColors = <Labelem, Color>{
    Labelem.midgrey: const Color.fromARGB(255, 128, 128, 128),
    Labelem.viridian: const Color.fromARGB(255, 64, 130, 109),
    Labelem.cerulean: const Color.fromARGB(255, 0, 123, 167),
  };

  Labelem _selectedSegment = Labelem.viridian;
  String account = '';
  TextEditingController accountController = TextEditingController();
  TextEditingController studentNumberController = TextEditingController();
  TextEditingController portController = TextEditingController();
  String accountType = Lang().accountType;
  int groupValue = 1;

  basicListener() async {
    if (examineeTokenNotifier.operationStatus.value == OperationStatus.loading) {
      showSnackBar(context, content: Lang().loading);
    } else if (examineeTokenNotifier.operationStatus.value == OperationStatus.success) {
      showSnackBar(context, content: Lang().theOperationCompletes);
    } else {
      showSnackBar(context, content: examineeTokenNotifier.operationMemo);
    }
  }

  @override
  void initState() {
    super.initState();
    examineeTokenNotifier.addListener(basicListener);
  }

  @override
  void dispose() {
    examineeTokenNotifier.dispose();
    examineeTokenNotifier.removeListener(basicListener);
    super.dispose();
  }

  void checkLang() {
    if (FileHelper().jsonRead(key: 'lang') == 'en') {
      setState(() {
        groupValue = 1;
      });
    } else if (FileHelper().jsonRead(key: 'lang') == 'cn') {
      setState(() {
        groupValue = 2;
      });
    } else {
      setState(() {
        groupValue = 0;
      });
    }
  }

  Row selectLang() {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        const SizedBox(width: 80),
        Radio(
          activeColor: Colors.white,
          value: 1,
          groupValue: groupValue,
          onChanged: (int? v) {
            setState(() {
              groupValue = v ?? 0;
              FileHelper().jsonWrite(key: 'lang', value: 'en');
              accountType = Lang().accountType;
            });
          },
        ),
        const Text('English', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        // const SizedBox(width: 20),
        Radio(
          activeColor: Colors.white,
          value: 2,
          groupValue: groupValue,
          onChanged: (int? v) {
            setState(() {
              groupValue = v ?? 0;
              FileHelper().jsonWrite(key: 'lang', value: 'cn');
              accountType = Lang().accountType;
            });
          },
        ),
        const Text('中文', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        // const Expanded(child: SizedBox()),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget body() {
    portController.text = '50001';

    bool connectionTestShow = false;
    bool examinationShow = false;
    bool selfTestShow = false;

    if (_selectedSegment.name == 'midgrey') {
      connectionTestShow = true;
    } else if (_selectedSegment.name == 'viridian') {
      examinationShow = true;
    } else if (_selectedSegment.name == 'cerulean') {
      selfTestShow = true;
    } else {
      connectionTestShow = false;
      examinationShow = false;
      selfTestShow = false;
    }

    void showActionSheet(BuildContext context) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          message: Text(
            Lang().pleaseSelect,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  accountType = Lang().studentNumber;
                  Navigator.pop(context);
                });
              },
              child: Text(
                Lang().studentNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  accountType = Lang().admissionTicketNumber;
                  Navigator.pop(context);
                });
              },
              child: Text(
                Lang().admissionTicketNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          selectLang(),
          const Expanded(child: SizedBox()),
          Visibility(
            visible: connectionTestShow,
            child: SizedBox(
              width: 300,
              child: TextField(
                controller: portController,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Visibility(visible: connectionTestShow, child: const SizedBox(height: 10)),
          Visibility(
            visible: connectionTestShow,
            child: SizedBox(
              width: 300,
              child: CupertinoButton.filled(
                padding: const EdgeInsets.all(10),
                child: Text(Lang().serverCommunicationTest, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                onPressed: () {
                  Tools().socketListen(context, int.parse(portController.text), 4);
                },
              ),
            ),
          ),
          Visibility(
            visible: examinationShow,
            child: SizedBox(
              width: 350,
              child: Tooltip(
                decoration: const BoxDecoration(color: Colors.grey),
                textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                message: Lang().enterToEnter,
                child: TextField(
                  controller: accountController,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.5),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: Lang().account,
                    hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    suffixIconColor: Colors.white,
                    suffixIcon: IconButton(
                      iconSize: 20,
                      onPressed: () => accountController.clear(),
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (accountController.text.isNotEmpty) {
                      if (accountType != Lang().accountType) {
                        Tools().clentUDP(int.parse(portController.text)).then((value) {
                          if (value.isNotEmpty) {
                            showSnackBar(context, content: Lang().loading);
                            FileHelper().writeFileAsync('ServerAddress', value).then((value) {
                              if (value == true) {
                                if (accountType == Lang().studentNumber) {
                                  examineeTokenNotifier.signInStudentID(account: accountController.text).then((value) {
                                    if (value.state) {
                                      examineeTokenNotifier.examInfoListModel = ExamInfoModel().fromJsonList(jsonEncode(value.data));
                                    } else {
                                      showSnackBar(context, content: value.memo);
                                    }
                                  });
                                }
                                if (accountType == Lang().admissionTicketNumber) {
                                  examineeTokenNotifier.signInAdmissionTicket(examNo: accountController.text);
                                }
                              }
                            });
                          } else {
                            showSnackBar(context, content: Lang().theRequestFailed);
                          }
                        });
                      } else {
                        showSnackBar(context, content: Lang().unknownAccountType);
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: examinationShow,
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                CupertinoButton(
                  onPressed: () => showActionSheet(context),
                  child: Text(
                    accountType,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_outlined, size: 15),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          Visibility(
            visible: selfTestShow,
            child: SizedBox(
              width: 350,
              child: Tooltip(
                decoration: const BoxDecoration(color: Colors.grey),
                textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                message: Lang().enterToEnter,
                child: TextField(
                  controller: studentNumberController,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.5),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: Lang().studentNumber,
                    hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    suffixIconColor: Colors.white,
                    suffixIcon: IconButton(
                      iconSize: 20,
                      onPressed: () => studentNumberController.clear(),
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (accountController.text.isNotEmpty) {
                      if (accountType == Lang().accountType) {
                        showSnackBar(context, content: Lang().unknownAccountType);
                      } else {
                        showSnackBar(context, content: 'error');
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkLang();

    return CupertinoPageScaffold(
      backgroundColor: labelColors[_selectedSegment],
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.black,
        middle: CupertinoSlidingSegmentedControl<Labelem>(
          backgroundColor: CupertinoColors.systemGrey2,
          thumbColor: labelColors[_selectedSegment]!,
          groupValue: _selectedSegment,
          onValueChanged: (Labelem? value) {
            if (value != null) {
              setState(() {
                _selectedSegment = value;
              });
            }
          },
          children: <Labelem, Widget>{
            Labelem.midgrey: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                Lang().connectionTest,
                style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Labelem.viridian: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                Lang().examination,
                style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Labelem.cerulean: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                Lang().selfTest,
                style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          },
        ),
      ),
      child: Center(child: body()),
    );
  }
}
