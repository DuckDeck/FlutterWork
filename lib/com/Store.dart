import 'package:mmkv/mmkv.dart';

//这样还远远不够。因为自定义变量无法保存
class Store<T extends num, string> {
  late String name;
  T? _value;
  late T _defaultValue;
  var _hasValue = false;
  var mmkv = MMKV.defaultMMKV();
  Store({required this.name, required defaultValue}) : _defaultValue = defaultValue;

  T get value {
    if (!_hasValue) {
      if (!mmkv.containsKey(name)) {
        if (_defaultValue is bool) {
          _value = mmkv.decodeBool(name) as T;
        }
        if (_defaultValue is int) {
          _value = mmkv.decodeInt(name) as T;
        }
        if (_defaultValue is string) {
          _value = mmkv.decodeString(name) as T;
        }
        if (_defaultValue is bool) {
          _value = mmkv.decodeDouble(name) as T;
        }
      } else {
        _value = _defaultValue;
        save();
      }
      _hasValue = true;
    }
    return _value!;
  }

  set value(T newValue) {
    () async {
      _value = newValue;
      _hasValue = true;
      save();
    }();
  }

  void clear() {
    mmkv.removeValue(name);
  }

  void save() {
    if (_value is bool) {
      mmkv.encodeBool(name, _value as bool);
    }
    if (_value is int) {
      mmkv.encodeInt(name, _value as int);
    }
    if (_value is double) {
      mmkv.encodeDouble(name, _value as double);
    }
    if (_value is String) {
      mmkv.encodeString(name, _value as String);
    }
  }

  // Future<bool> fileExist() async {
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   var path = Directory(dir + "/" + name);
  //   if (!path.existsSync()) {
  //     return false;
  //   }
  //   return true;
  // }

  // Future<File> getDataFile() async {
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   var path = Directory(dir + "/" + name);
  //   if (!path.existsSync()) {
  //     path.createSync();
  //   }
  //   final filePath = path.path + "/" + name;
  //   return new File(filePath);
  // }

  // Future<T> getValue() async {
  //   final file = await getDataFile();
  //   final contents = await file.readAsString();
  //   return jsonDecode(contents);
  // }

  // void setValue(T value) async {
  //   final file = await getDataFile();
  //   final data = jsonEncode(value);
  //   file.writeAsString(data);
  // }
}
