import 'package:dio/dio.dart';
import 'package:flutter_work/com/Result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fiveStroke.g.dart';

@JsonSerializable()
class FiveStroke {
  @JsonKey(name: "ID")
  int id;
  @JsonKey(name: "Word")
  String text;
  @JsonKey(name: "PinYin")
  String pinyin;
  @JsonKey(name: "ImgCode")
  String img;
  @JsonKey(name: "FiveCode")
  String code;
  FiveStroke({this.id = 0, this.text = "", this.pinyin = "", this.img = "", this.code = ""});
  factory FiveStroke.fromJson(Map<String, dynamic> json) => _$FiveStrokeFromJson(json);

  Map<String, dynamic> toJson() => _$FiveStrokeToJson(this);

  static Future<ResultInfo> getFiveStroke(String words) async {
    var resData = ResultInfo();
    Dio dio = Dio();
    Response res = await dio.get("http://lovelive.ink:9000/five/" + words);
    if (res.statusCode! != 200) {
      resData.code = res.statusCode! - 500;
      resData.msg = res.statusMessage!;
      return resData;
    }
    print(res.data.runtimeType);
    Map<String, dynamic> data = res.data;
    resData.code = data["code"] as int;
    resData.msg = data["msg"] as String;
    resData.data = data["data"];
    if (resData.code != 0) {
      return resData;
    }
    List<dynamic> items = resData.data;
    List<FiveStroke> fives = <FiveStroke>[];
    for (var item in items) {
      final five = FiveStroke.fromJson(item);
      fives.add(five);
    }
    resData.data = fives;
    return resData;
  }
}
