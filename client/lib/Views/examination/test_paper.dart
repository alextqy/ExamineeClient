import 'package:flutter/material.dart';
import 'package:client/public/lang.dart';

// ignore: must_be_immutable
class TestPaper extends StatefulWidget {
  const TestPaper({super.key});

  @override
  State<TestPaper> createState() => TestPaperState();
}

class TestPaperState extends State<TestPaper> {
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
      appBar: AppBar(automaticallyImplyLeading: false, title: Text(Lang().title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
      body: mainWidget(context),
    );
  }
}
