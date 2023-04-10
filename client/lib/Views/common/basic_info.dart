import 'package:flutter/material.dart';
import 'package:client/public/lang.dart';
import 'package:client/Views/common/toast.dart';

List<int> perPageDropList = <int>[10, 50, 100];
List<String> stateDropList = <String>[
  Lang().all,
  Lang().normal,
  Lang().disable,
];

List<String> examStatusList = <String>[
  Lang().notSelected,
  Lang().noAnswerCards,
  Lang().notExamined,
  Lang().examined,
  Lang().examVoided,
];

List<String> examTypeList = <String>[
  Lang().notSelected,
  Lang().officialExams,
  Lang().dailyPractice,
];

List<String> passList = <String>[
  Lang().notSelected,
  Lang().yes,
  Lang().no,
];

List<String> startStateList = <String>[
  Lang().notSelected,
  Lang().notStarted,
  Lang().started,
];

List<String> suspendedStateList = <String>[
  Lang().notSelected,
  Lang().yes,
  Lang().no,
];

List<String> questionTypeList = <String>[
  Lang().notSelected,
  Lang().multipleChoiceQuestions,
  Lang().judgmentQuestions,
  Lang().multipleSelection,
  Lang().fillInTheBlanks,
  Lang().quizQuestions,
  Lang().codeTesting,
  Lang().drag,
  Lang().connection,
];

List<String> languageList = <String>[
  Lang().notSelected,
  'php',
  'javascript',
  'python',
  'java',
  'c',
];

List<String> correctAnswerList = <String>[
  Lang().notSelected,
  Lang().yes,
  Lang().no,
];

String checkCorrectAnswer(int correctAnswer) {
  if (correctAnswer == 1) {
    return Lang().wrong;
  } else if (correctAnswer == 2) {
    return Lang().right;
  } else {
    return '';
  }
}

List<String> positionList = <String>[
  Lang().notSelected,
  Lang().leftSide,
  Lang().rightSide,
];

String checkPosition(int position) {
  if (position == 1) {
    return Lang().leftSide;
  } else if (position == 2) {
    return Lang().rightSide;
  } else {
    return '';
  }
}

String checkQuestionType(int questionType) {
  if (questionType == 1) {
    return Lang().multipleChoiceQuestions;
  } else if (questionType == 2) {
    return Lang().judgmentQuestions;
  } else if (questionType == 3) {
    return Lang().multipleSelection;
  } else if (questionType == 4) {
    return Lang().fillInTheBlanks;
  } else if (questionType == 5) {
    return Lang().quizQuestions;
  } else if (questionType == 6) {
    return Lang().codeTesting;
  } else if (questionType == 7) {
    return Lang().drag;
  } else if (questionType == 8) {
    return Lang().connection;
  } else {
    return '';
  }
}

List<String> logTypeList = <String>[
  Lang().notSelected,
  Lang().operation,
  Lang().login,
];

String checkLogType(int type) {
  if (type == 1) {
    return Lang().operation;
  } else if (type == 2) {
    return Lang().login;
  } else {
    return '';
  }
}

Tooltip questionMark(BuildContext context, String languageMemo) {
  return Tooltip(
    message: Lang().languageVersion,
    child: IconButton(
      padding: const EdgeInsets.all(0.0),
      icon: const Icon(Icons.question_mark, size: 15),
      onPressed: () {
        if (languageMemo == 'php') {
          Toast().show(context, message: 'latest or ver.5 ver.7 ver.8');
        } else if (languageMemo == 'javascript') {
          Toast().show(context, message: 'latest or ver.4 ~ ver.18');
        } else if (languageMemo == 'python') {
          Toast().show(context, message: 'latest or ver.3+');
        } else if (languageMemo == 'java') {
          Toast().show(context, message: 'latest or ver.6 ~ ver.20');
        } else if (languageMemo == 'c') {
          Toast().show(context, message: 'latest or ver.4 ~ ver.12');
        } else {
          Toast().show(context, message: 'prompt');
        }
      },
    ),
  );
}
