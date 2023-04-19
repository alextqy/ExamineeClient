// ignore_for_file: unnecessary_this
import 'package:client/public/file.dart';

class Lang {
  String type = '';
  String none = '';
  String title = '';
  String connectionTest = '';
  String serverCommunicationTest = '';
  String examination = '';
  String selfTest = '';
  String account = '';
  String incorrectInput = '';
  String theRequestFailed = '';
  String cancel = '';
  String confirm = '';
  String accountType = '';
  String pleaseSelect = '';
  String studentNumber = '';
  String admissionTicketNumber = '';
  String enterToEnter = '';
  String unknownAccountType = '';
  String requestTimedOut = '';
  String loading = '';
  String theOperationCompletes = '';
  String noRegistrationDataAvailable = '';
  String examSubjects = '';
  String examDuration = '';
  String passLine = '';
  String selectTheSubject = '';
  String startExam = '';

  Lang({this.title = 'Bit Exam'}) {
    this.type = FileHelper().jsonRead(key: 'lang', filePath: 'config.json');
    if (this.type == 'cn') {
      this.none = '';
      this.title = title;
      this.connectionTest = '连接测试';
      this.serverCommunicationTest = '服务器通讯测试';
      this.examination = '考试';
      this.selfTest = '自测';
      this.account = '账号';
      this.incorrectInput = '输入错误';
      this.theRequestFailed = '请求失败';
      this.cancel = '取消';
      this.confirm = '确认';
      this.accountType = '账号类型';
      this.pleaseSelect = '请选择';
      this.studentNumber = '学号';
      this.admissionTicketNumber = '准考证号';
      this.enterToEnter = '回车进入';
      this.unknownAccountType = '未知账号类型';
      this.requestTimedOut = '请求超时';
      this.loading = '加载中';
      this.theOperationCompletes = '操作完成';
      this.noRegistrationDataAvailable = '暂无报名数据';
      this.examSubjects = '考试科目';
      this.examDuration = '考试时长';
      this.passLine = '及格线';
      this.selectTheSubject = '选择该科目';
      this.startExam = '开始考试';
    } else {
      this.none = '';
      this.title = title;
      this.connectionTest = 'Connection Test';
      this.serverCommunicationTest = 'Server Communication Test';
      this.examination = 'Examination';
      this.selfTest = 'Self-test';
      this.account = 'Account';
      this.incorrectInput = 'Incorrect Input';
      this.theRequestFailed = 'The Request Failed';
      this.cancel = 'Cancel';
      this.confirm = 'Confirm';
      this.accountType = 'Account Type';
      this.pleaseSelect = 'Please Select';
      this.studentNumber = 'Student Number';
      this.admissionTicketNumber = 'Admission Ticket Number';
      this.enterToEnter = 'Enter To Enter';
      this.unknownAccountType = 'Unknown Account Type';
      this.requestTimedOut = 'Request Timed Out';
      this.loading = 'Loading';
      this.theOperationCompletes = 'Completed';
      this.noRegistrationDataAvailable = 'No Registration Data Available';
      this.examSubjects = 'Exam Subjects';
      this.examDuration = 'Exam Duration';
      this.passLine = 'Pass Line';
      this.selectTheSubject = 'Select The Subject';
      this.startExam = 'Start Exam';
    }
  }
}
