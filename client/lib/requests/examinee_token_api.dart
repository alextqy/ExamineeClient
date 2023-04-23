// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart';
import 'package:client/public/file.dart';
import 'package:client/requests/base.dart';
import 'package:client/models/data.dart';

class ExamineeTokenApi extends ResponseHelper {
  Future<DataModel> signInStudentID({
    String account = '',
  }) async {
    Response response = await post(
      Uri.http(url, '/Sign/In/Student/ID'),
      body: {
        'Account': account,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return DataModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<DataModel> signInAdmissionTicket({
    String examNo = '',
  }) async {
    Response response = await post(
      Uri.http(url, '/Sign/In/Admission/Ticket'),
      body: {
        'ExamNo': examNo,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return DataModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<DataModel> examScantronList() async {
    Response response = await post(
      Uri.http(url, '/Exam/Scantron/List'),
      body: {
        'Token': FileHelper().readFile('token'),
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return DataModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<DataModel> examScantronSolutionInfo({
    int id = 0,
  }) async {
    Response response = await post(
      Uri.http(url, '/Exam/Scantron/Solution/Info'),
      body: {
        'Token': FileHelper().readFile('token'),
        'ID': id.toString(),
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return DataModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<DataModel> examAnswer({
    int scantronID = 0,
    int id = 0,
    String answer = '',
  }) async {
    Response response = await post(
      Uri.http(url, '/Exam/Answer'),
      body: {
        'Token': FileHelper().readFile('token'),
        'ScantronID': scantronID.toString(),
        'ID': id.toString(),
        'Answer': answer,
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return DataModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }

  Future<DataModel> endTheExam() async {
    Response response = await post(
      Uri.http(url, '/End/The/Exam'),
      body: {
        'Token': FileHelper().readFile('token'),
      },
      headers: postHeaders,
      encoding: postEncoding,
    );
    return DataModel.fromJson(jsonDecode(decoder.convert(response.bodyBytes)));
  }
}
