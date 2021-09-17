import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

//这样还远远不够。因为自定义变量无法保存
// 目前还没有发现dart内好的归档办法，所以这个可能还不好用。
// class Store<T> {
//   late String name;
//   T? _value;
//   late T _defaultValue;
//   var _hasValue = false;
//   var mmkv = MMKV.defaultMMKV();
//   Store({required this.name, required defaultValue}) : _defaultValue = defaultValue;

//   T get value {
//     if (!_hasValue) {
//       if (mmkv.containsKey(name)) {
//         if (_defaultValue is bool) {
//           print("取出Bool");
//           _value = mmkv.decodeBool(name) as T;
//         } else if (_defaultValue is int) {
//           _value = mmkv.decodeInt(name) as T;
//         } else if (_defaultValue is double) {
//           _value = mmkv.decodeDouble(name) as T;
//         } else if (_defaultValue is String) {
//           _value = mmkv.decodeString(name) as T;
//         } else if (_defaultValue is bool) {
//           _value = mmkv.decodeDouble(name) as T;
//         } else if (_defaultValue is JsonSerializable) {
//           var js = mmkv.decodeString(name);
//           _value = jsonDecode(js!) as T;
//         } else {
//           throw Exception("Invalid Data");
//         }
//       } else {
//         _value = _defaultValue;
//         save();
//       }
//       _hasValue = true;
//     }
//     return _value!;
//   }

//   set value(T newValue) {
//     () async {
//       _value = newValue;
//       _hasValue = true;
//       save();
//     }();
//   }

//   void clear() {
//     mmkv.removeValue(name);
//   }

//   void save() {
//     print("------------将要保存:$_value------------");
//     var type = _value.runtimeType.toString();
//     print("------------数据类型是:$type------------");
//     if (_value is bool) {
//       mmkv.encodeBool(name, _value as bool);
//     }
//     if (_value is int) {
//       mmkv.encodeInt(name, _value as int);
//     }
//     if (_value is double) {
//       mmkv.encodeDouble(name, _value as double);
//     }
//     if (_value is String) {
//       mmkv.encodeString(name, _value as String);
//     }
//     if (_value is JsonSerializable) {
//       var js = jsonEncode(_value as JsonSerializable);
//       mmkv.encodeString(name, js);
//     }
//   }

//   Future<bool> fileExist() async {
//     String dir = (await getApplicationDocumentsDirectory()).path;
//     var path = Directory(dir + "/" + name);
//     if (!path.existsSync()) {
//       return false;
//     }
//     return true;
//   }

//   Future<File> getDataFile() async {
//     String dir = (await getApplicationDocumentsDirectory()).path;
//     var path = Directory(dir + "/" + name);
//     if (!path.existsSync()) {
//       path.createSync();
//     }
//     final filePath = path.path + "/" + name;
//     return new File(filePath);
//   }

//   Future<T> getValue() async {
//     final file = await getDataFile();
//     final contents = await file.readAsString();
//     return jsonDecode(contents);
//   }

//   void setValue(T value) async {
//     final file = await getDataFile();
//     final data = jsonEncode(value);
//     file.writeAsString(data);
//   }
// }
