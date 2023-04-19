// ignore_for_file: file_names

import 'dart:convert';
import 'package:client/models/base.dart';

class ScantronSolutionModel extends BaseModel {
  late int scantronID;
  late String option;
  late String optionAttachment;
  late int correctAnswer;
  late String correctItem;
  late double scoreRatio;
  late int position;
  late int updateTime;
  late String candidateAnswer;
  // late bool selected;

  ScantronSolutionModel({
    int id = 0,
    int createTime = 0,
    this.scantronID = 0,
    this.option = '',
    this.optionAttachment = '',
    this.correctAnswer = 0,
    this.correctItem = '',
    this.scoreRatio = 0,
    this.position = 0,
    this.updateTime = 0,
    this.candidateAnswer = '',
    // this.selected = false,
  }) : super(id, createTime);

  factory ScantronSolutionModel.fromJson(Map<String, dynamic> json) {
    return ScantronSolutionModel(
      id: json['ID'],
      createTime: json['CreateTime'],
      scantronID: json['ScantronID'],
      option: json['Option'],
      optionAttachment: json['OptionAttachment'],
      correctAnswer: json['CorrectAnswer'],
      correctItem: json['CorrectItem'],
      scoreRatio: json['ScoreRatio'],
      position: json['Position'],
      updateTime: json['UpdateTime'],
      candidateAnswer: json['CandidateAnswer'],
    );
  }

  List<ScantronSolutionModel> fromJsonList(String jsonString) {
    List<ScantronSolutionModel> dataList = (jsonDecode(jsonString) as List).map((i) => ScantronSolutionModel.fromJson(i)).toList();
    return dataList;
  }
}
