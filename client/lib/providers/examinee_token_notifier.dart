// ignore_for_file: file_names

import 'package:client/providers/base_notifier.dart';
import 'package:client/models/data_list.dart';

class ExamineeTokenNotifier extends BaseNotifier {
  void signInStudentID({
    required String account,
  }) async {
    operationStatus.value = OperationStatus.loading;
    try {
      result = await examineeTokenApi.signInStudentID(
        account: account,
      );
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

  void signInAdmissionTicket({
    required String examNo,
  }) async {
    operationStatus.value = OperationStatus.loading;
    try {
      result = await examineeTokenApi.signInAdmissionTicket(
        examNo: examNo,
      );
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

  Future<DataListModel> examScantronList() async {
    return await examineeTokenApi.examScantronList();
  }

  void examScantronSolutionInfo({
    required int id,
  }) async {
    operationStatus.value = OperationStatus.loading;
    try {
      result = await examineeTokenApi.examScantronSolutionInfo(
        id: id,
      );
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

  void examAnswer({
    required int scantronID,
    required int id,
    required String answer,
  }) async {
    operationStatus.value = OperationStatus.loading;
    try {
      result = await examineeTokenApi.examAnswer(
        scantronID: scantronID,
        id: id,
        answer: answer,
      );
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
