// ignore_for_file: file_names

import 'dart:convert';
import 'package:client/models/base.dart';

class ScantronModel extends BaseModel {
  late String questionTitle;
  late String questionCode;
  late int questionType;
  late int marking;
  late int knowledgeID;
  late String description;
  late String attachment;
  late int updateTime;
  late double score;
  late int examID;
  late String headlineContent;
  late int right;
  late String language;
  late String languageVersion;
  // late bool selected;

  ScantronModel({
    int id = 0,
    int createTime = 0,
    this.questionTitle = '',
    this.questionCode = '',
    this.questionType = 0,
    this.marking = 0,
    this.knowledgeID = 0,
    this.description = '',
    this.attachment = '',
    this.updateTime = 0,
    this.score = 0,
    this.examID = 0,
    this.headlineContent = '',
    this.right = 0,
    this.language = '',
    this.languageVersion = '',
    // this.selected = false,
  }) : super(id, createTime);

  factory ScantronModel.fromJson(Map<String, dynamic> json) {
    return ScantronModel(
      id: json['ID'],
      createTime: json['CreateTime'],
      questionTitle: json['QuestionTitle'],
      questionCode: json['QuestionCode'],
      questionType: json['QuestionType'],
      marking: json['Marking'],
      knowledgeID: json['KnowledgeID'],
      description: json['Description'],
      attachment: json['Attachment'],
      updateTime: json['UpdateTime'],
      score: json['Score'],
      examID: json['ExamID'],
      headlineContent: json['HeadlineContent'],
      right: json['Right'],
      language: json['Language'],
      languageVersion: json['LanguageVersion'],
    );
  }

  List<ScantronModel> fromJsonList(String jsonString) {
    List<ScantronModel> dataList = (jsonDecode(jsonString) as List).map((i) => ScantronModel.fromJson(i)).toList();
    return dataList;
  }
}
