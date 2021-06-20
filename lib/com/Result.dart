import 'package:dio/dio.dart';

class ResultInfo {
  var code = 0;
  var msg = "";
  dynamic data;
  var count = 0;

  static ResultInfo toResult(Response res) {
    var result = ResultInfo();
    if (res.statusCode != 200) {
      result.code = res.statusCode! - 500;
      result.msg = res.statusMessage!;
      return result;
    }
    Map<String, dynamic> data = res.data;
    result.code = data["code"] as int;
    result.msg = data["msg"] as String;
    result.data = data["data"];
    return result;
  }
}
