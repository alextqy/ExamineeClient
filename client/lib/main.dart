// import 'package:client/public/lang.dart';
// import 'package:client/public/file.dart';
// import 'package:client/udp_set.dart';

/*

void main() {
  if (FileHelper().jsonRead(key: 'lang') == '') {
    FileHelper().jsonWrite(key: 'lang', value: 'en');
  }
  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
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
  int groupValue = 1;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: null);
  }
}

*/

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/public/lang.dart';
import 'package:client/Views/common/black_white.dart';

enum Labelem { midgrey, viridian, cerulean }

Map<Labelem, Color> labelColors = <Labelem, Color>{
  Labelem.midgrey: const Color.fromARGB(255, 128, 128, 128),
  Labelem.viridian: const Color.fromARGB(255, 64, 130, 109),
  Labelem.cerulean: const Color.fromARGB(255, 0, 123, 167),
};

void main() => runApp(const ExamApp());

class ExamApp extends StatelessWidget {
  const ExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: black,
      ),
      home: const Scaffold(body: Entrance()),
    );
  }
}

class Entrance extends StatefulWidget {
  const Entrance({super.key});

  @override
  State<Entrance> createState() => EntranceState();
}

class EntranceState extends State<Entrance> {
  Labelem _selectedSegment = Labelem.viridian;
  String account = '';
  TextEditingController accountController = TextEditingController();
  String accountType = Lang().accountType;

  Widget body() {
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
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 300,
            child: Tooltip(
              decoration: const BoxDecoration(color: Colors.grey),
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.5),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  hintText: Lang().account,
                  suffixIconColor: Colors.white,
                  suffixIcon: IconButton(
                    iconSize: 20,
                    onPressed: () => accountController.clear(),
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              CupertinoButton(
                onPressed: () => showActionSheet(context),
                child: Text(
                  accountType,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: body(),
      ),
    );
  }
}
