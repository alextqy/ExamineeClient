// ignore_for_file: file_names

import 'dart:convert';
import 'package:client/models/data.dart';
import 'package:http/http.dart';
import 'package:client/public/file.dart';
// import 'package:http_parser/http_parser.dart';

class ResponseHelper {
  Utf8Decoder decoder = const Utf8Decoder();
  String url = FileHelper().readFile('ServerAddress');

  // String token = '';
  // header('sAccess-Control-Allow-Origin:*');
  // header('Access-Control-Allow-Methods:POST');
  // header('Access-Control-Allow-Headers:x-requested-with, content-type');
  // header('Content-type:text/json');
  Map<String, String> postHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'x-requested-with, content-type',
  };
  Encoding? postEncoding = Encoding.getByName('utf-8');

  Future<DataModel> upload({
    required String url,
    required String uri,
    required String filePath,
    String filename = '',
    int id = 0,
    String excelFile = '',
    String attachment = '',
    String contentType = '',
  }) async {
    String fromPathField = '';
    if (excelFile.trim().isNotEmpty) {
      fromPathField = excelFile.trim();
    } else {
      fromPathField = attachment.trim();
    }
    MultipartRequest request = MultipartRequest('post', Uri.parse('http://$url$uri'));
    request.fields['Token'] = FileHelper().readFile('token');
    request.fields['ContentType'] = contentType;
    request.fields['ID'] = id.toString();

    MultipartFile multipartFile = await MultipartFile.fromPath(
      fromPathField,
      filePath,
      filename: filename,
      // contentType: MediaType(contentType, filePath.substring(filePath.lastIndexOf('.') + 1, filePath.length)),
    );
    request.files.add(multipartFile);
    StreamedResponse response = await request.send();
    String respStr = await response.stream.transform(utf8.decoder).join();
    Map<String, dynamic> respStrMap = jsonDecode(respStr);
    return DataModel.fromJson(respStrMap);
    // return response;
    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   return false;
    // }
  }
}
