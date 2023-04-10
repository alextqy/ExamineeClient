// ignore_for_file: file_names

import 'dart:convert';
import 'package:client/models/base.dart';

class ExamineeTokenModel extends BaseModel {
  late String token;
  late int examID;
  late bool selected;

  ExamineeTokenModel({
    int id = 0,
    int createTime = 0,
    this.token = '',
    this.examID = 0,
    this.selected = false,
  }) : super(id, createTime);

  factory ExamineeTokenModel.fromJson(Map<String, dynamic> json) {
    return ExamineeTokenModel(
      id: json['ID'],
      createTime: json['CreateTime'],
      token: json['Token'],
      examID: json['ExamID'],
    );
  }

  List<ExamineeTokenModel> fromJsonList(String jsonString) {
    List<ExamineeTokenModel> dataList = (jsonDecode(jsonString) as List).map((i) => ExamineeTokenModel.fromJson(i)).toList();
    return dataList;
  }
}
