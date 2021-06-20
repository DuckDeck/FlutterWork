class CatInfo {
  CatInfo({this.name, this.urlSegment});
  final String? name;
  final String? urlSegment;
}

class ImgInfo {
  ImgInfo({this.imgName = "", this.imgPage = "", this.imgUrl = ""});
  var imgPage = "";
  var imgUrl = "";
  var imgName = "";
  @override
  String toString() {
    return "图片地址$imgUrl _ 图片名 $imgName";
  }
}

class ImgDetail {
  var imgUrl = "";
  Resolution? resolution;
  var size = 0.0;
  var sizeStr = "";
  var updateTimeStr = "";
  List<ImgInfo>? moreImages;

  @override
  String toString() {
    return "图片地址$imgUrl _ 图片解析度$resolution _ 图片大小 $sizeStr";
  }
}

class Resolution {
  Resolution({this.width = 0, this.height = 0});
  var width = 0;
  var height = 0;
  get rate {
    return width.toDouble() / height.toDouble();
  }

  static Resolution parse(String str) {
    if (str.contains("x") || str.contains("X")) {
      final parts = str.toLowerCase().split("x");
      if (parts.last.length == 0) {
        return Resolution(width: 0, height: 0);
      }
      return Resolution(
          width: int.parse(parts.first), height: int.parse(parts.last));
    } else {
      return Resolution(width: 0, height: 0);
    }
  }

  @override
  String toString() {
    return "$width X $height";
  }
}

class UserInfo {
  var head = "";
  var name = "";
}
