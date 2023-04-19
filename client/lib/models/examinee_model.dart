// ignore_for_file: file_names

import 'dart:convert';
import 'package:client/models/base.dart';

class ExamineeModel extends BaseModel {
  late String examineeNo;
  late String name;
  late int classID;
  late String contact;
  // late bool selected;

  ExamineeModel({
    int id = 0,
    int createTime = 0,
    this.examineeNo = '',
    this.name = '',
    this.classID = 0,
    this.contact = '',
    // this.selected = false,
  }) : super(id, createTime);

  factory ExamineeModel.fromJson(Map<String, dynamic> json) {
    return ExamineeModel(
      id: json['ID'],
      createTime: json['CreateTime'],
      examineeNo: json['ExamineeNo'],
      name: json['Name'],
      classID: json['ClassID'],
      contact: json['Contact'],
    );
  }

  List<ExamineeModel> fromJsonList(String jsonString) {
    List<ExamineeModel> dataList = (jsonDecode(jsonString) as List).map((i) => ExamineeModel.fromJson(i)).toList();
    return dataList;
  }
}
