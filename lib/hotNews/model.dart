import 'package:flutter_work/com/Base.dart';

class NewsInfo {
  var id = 0;
  var title = "";
  var source = "";
  var newsImg = "";
  CatInfo? newsCat;
  var updateTime = 0;
  String get releaseTime {
    var t = DateTime.fromMillisecondsSinceEpoch(updateTime * 1000);
    var now = DateTime.now();
    var interval = now.difference(t);
    print(interval.inSeconds);
    if (interval.inSeconds < 60) {
      return "${interval.inSeconds}秒前";
    } else if (interval.inSeconds > 60 && interval.inSeconds < 3600) {
      return "${interval.inSeconds ~/ 60}分钟前";
    }
    return "${interval.inSeconds ~/ 3600}小时前";
  }

  var hotDesc = "";
  var isNew = true;
  var isCollect = false;
}
