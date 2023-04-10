class DataModel {
  bool state = false;
  String memo = '';
  int code = 0;
  dynamic data;

  DataModel({
    this.state = false,
    this.memo = '',
    this.code = 0,
    this.data,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      state: json['State'],
      memo: json['Memo'],
      code: json['Code'],
      data: json['Data'],
    );
  }
}
