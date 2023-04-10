// ignore_for_file: file_names
import 'package:flutter/widgets.dart';

import 'package:client/models/data.dart';
import 'package:client/models/data_list.dart';
import 'package:client/models/examinfo_model.dart';
import 'package:client/models/examinee_model.dart';
import 'package:client/models/examinee_token_model.dart';
import 'package:client/models/scantron_model.dart';
import 'package:client/models/scantron_solution_model.dart';

import 'package:client/requests/examinee_token_api.dart';

enum OperationStatus {
  /// 加载中
  init,

  /// 加载中
  loading,

  /// 加载成功
  success,

  /// 加载成功，但数据为空
  empty,

  /// 加载失败
  failure,

  /// 请求失败
  disconnection,
}

class ApiResponse<T> {
  OperationStatus status;
  T? data;
  String? message;

  ApiResponse.init(this.message) : status = OperationStatus.init;

  ApiResponse.loading(this.message) : status = OperationStatus.loading;

  ApiResponse.success(this.data) : status = OperationStatus.success;

  ApiResponse.empty(this.message) : status = OperationStatus.empty;

  ApiResponse.failure(this.message) : status = OperationStatus.failure;

  ApiResponse.disconnection(this.message) : status = OperationStatus.disconnection;
}

class BaseNotifier extends ChangeNotifier {
  ValueNotifier operationStatus = ValueNotifier(OperationStatus.loading);
  String operationMemo = '';
  int operationCode = 0;

  late DataModel result;
  late DataListModel resultList;

  /// model ===================================================================
  ExamineeModel examineeModel = ExamineeModel();
  ExamineeTokenModel examineeTokenModel = ExamineeTokenModel();
  ExamInfoModel examInfoModel = ExamInfoModel();
  ScantronModel scantronModel = ScantronModel();
  ScantronSolutionModel scantronSolutionModel = ScantronSolutionModel();

  /// model list ===================================================================
  List<ExamineeModel> examineeListModel = [];
  List<ExamineeTokenModel> examineeTokenListModel = [];
  List<ExamInfoModel> examInfoListModel = [];
  List<ScantronModel> scantronListModel = [];
  List<ScantronSolutionModel> scantronSolutionListModel = [];

  /// api ===================================================================
  ExamineeTokenApi examineeTokenApi = ExamineeTokenApi();
}
