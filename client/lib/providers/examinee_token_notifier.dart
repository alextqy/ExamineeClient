// ignore_for_file: file_names

import 'package:client/models/data.dart';
import 'package:client/providers/base_notifier.dart';

class ExamineeTokenNotifier extends BaseNotifier {
  Future<DataModel> signInStudentID({
    required String account,
  }) async {
    operationStatus.value = OperationStatus.loading;
    return await examineeTokenApi.signInStudentID(account: account);
  }

  Future<DataModel> signInAdmissionTicket({
    required String examNo,
  }) async {
    operationStatus.value = OperationStatus.loading;
    return await examineeTokenApi.signInAdmissionTicket(examNo: examNo);
  }

  Future<DataModel> examScantronList() async {
    return await examineeTokenApi.examScantronList();
  }

  Future<DataModel> examScantronSolutionInfo({
    required int id,
  }) async {
    return await examineeTokenApi.examScantronSolutionInfo(id: id);
  }

  Future<DataModel> examScantronSolutionViewAttachments({
    required String filePath,
  }) async {
    return await examineeTokenApi.examScantronSolutionViewAttachments(filePath: filePath);
  }

  Future<DataModel> examAnswer({
    required int scantronID,
    required int id,
    required String answer,
  }) async {
    return await examineeTokenApi.examAnswer(
      scantronID: scantronID,
      id: id,
      answer: answer,
    );
  }

  void endTheExam() async {
    operationStatus.value = OperationStatus.loading;
    try {
      result = await examineeTokenApi.endTheExam();
      if (result.state == true) {
        operationStatus.value = OperationStatus.success;
      } else {
        operationStatus.value = OperationStatus.failure;
        operationMemo = result.memo;
      }
    } catch (e) {
      operationStatus.value = OperationStatus.failure;
      operationMemo = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
