// ignore_for_file: unnecessary_this
import 'package:client/public/file.dart';

class Lang {
  String type = '';
  String title = '';
  String connectionTest = '';
  String serverCommunicationTest = '';
  String examination = '';
  String selfTest = '';
  String account = '';
  String incorrectInput = '';
  String theRequestFailed = '';
  String cancel = '';
  String accountType = '';
  String pleaseSelect = '';
  String studentNumber = '';
  String admissionTicketNumber = '';
  String enterToEnter = '';
  String unknownAccountType = '';
  String requestTimedOut = '';
  String loading = '';
  String theOperationCompletes = '';

  Lang({this.title = 'Bit Exam'}) {
    this.type = FileHelper().jsonRead(key: 'lang', filePath: 'config.json');
    if (this.type == 'cn') {
      this.title = title;
      this.connectionTest = '连接测试';
      this.serverCommunicationTest = '服务器通讯测试';
      this.examination = '考试';
      this.selfTest = '自测';
      this.account = '账号';
      this.incorrectInput = '输入错误';
      this.theRequestFailed = '请求失败';
      this.cancel = '取消';
      this.accountType = '账号类型';
      this.pleaseSelect = '请选择';
      this.studentNumber = '学号';
      this.admissionTicketNumber = '准考证号';
      this.enterToEnter = '回车进入';
      this.unknownAccountType = '未知账号类型';
      this.requestTimedOut = '请求超时';
      this.loading = '加载中';
      this.theOperationCompletes = '操作完成';
    } else {
      this.title = title;
      this.connectionTest = 'Connection Test';
      this.serverCommunicationTest = 'Server Communication Test';
      this.examination = 'Examination';
      this.selfTest = 'Self-test';
      this.account = 'account';
      this.incorrectInput = 'Incorrect Input';
      this.theRequestFailed = 'The Request Failed';
      this.cancel = 'cancel';
      this.accountType = 'Account Type';
      this.pleaseSelect = 'Please Select';
      this.studentNumber = 'Student Number';
      this.admissionTicketNumber = 'Admission Ticket Number';
      this.enterToEnter = 'Enter To Enter';
      this.unknownAccountType = 'Unknown Account Type';
      this.requestTimedOut = 'Request Timed Out';
      this.loading = 'Loading';
      this.theOperationCompletes = 'Completed';
    }
  }
}
