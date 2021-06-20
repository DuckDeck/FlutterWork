// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fiveStroke.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiveStroke _$FiveStrokeFromJson(Map<String, dynamic> json) {
  return FiveStroke(
    id: json['ID'] as int,
    text: json['Word'] as String,
    pinyin: json['PinYin'] as String,
    img: json['ImgCode'] as String,
    code: json['FiveCode'] as String,
  );
}

Map<String, dynamic> _$FiveStrokeToJson(FiveStroke instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Word': instance.text,
      'PinYin': instance.pinyin,
      'ImgCode': instance.img,
      'FiveCode': instance.code,
    };
