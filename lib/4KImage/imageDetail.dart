import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_work/4KImage/model.dart';
import 'package:dio/dio.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as html;
import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageDetail extends StatefulWidget {
  ImageDetail({this.imgInfo});
  final ImgInfo? imgInfo;

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  ImgDetail? imgDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.imgInfo!.imgName),
        ),
        body: FutureBuilder<ImgDetail>(
            future: _getData(),
            builder: (BuildContext context, AsyncSnapshot<ImgDetail> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                case ConnectionState.none:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  print(snapshot.data);
                  if (snapshot.data == null) {
                    return Center(child: Text("HTML解析失败"));
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(minHeight: 400 / snapshot.data!.resolution!.rate),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data!.imgUrl,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: <Widget>[
                                Text("尺寸:${snapshot.data!.resolution.toString()}"),
                                Text("体积:${snapshot.data!.sizeStr}"),
                                Text("上传时间:${snapshot.data!.updateTimeStr}")
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                ElevatedButton(
                                  child: Text("下载"),
                                  onPressed: () {
                                    saveImage(snapshot.data!.imgUrl);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  child: Text("原图下载"),
                                  onPressed: () {
                                    Fluttertoast.showToast(msg: "下载原图需要登录才行,现在开始登录");
                                    toLogin();
                                  },
                                )
                              ],
                            ),
                          ),
                          Text("更多相似图片"),
                          Column(
                            children: snapshot.data!.moreImages!.map((item) {
                              return GestureDetector(
                                  child: Image.network(item.imgUrl),
                                  onTap: () {
                                    toPage(item);
                                  });
                            }).toList(),
                          )
                        ],
                      ),
                    );
                  }
              }
            }));
  }

  void toLogin() {}

  void toPage(ImgInfo item) {
    print("will go" + item.imgPage);
    if (item.imgPage == "https://pic.netbian.com/4kdongman/") {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) {
      return ImageDetail(
        imgInfo: item,
      );
    }));
  }

  void saveImage(String img) async {
    var response = await Dio().get(img, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print("下载结果" + result);
    if (result is String) {
      Fluttertoast.showToast(msg: "下载成功，但是下载原图需要登录才行");
    } else {
      Fluttertoast.showToast(msg: "下载失败");
    }
  }

  Future<ImgDetail> _getData() async {
    Dio dio = Dio();
    final imgDetail = ImgDetail();
    dio.options.responseType = ResponseType.bytes;
    print(widget.imgInfo!.imgPage);

    Response<List<int>> res = await dio.get<List<int>>(widget.imgInfo!.imgPage);
    final result = gbk_bytes.decode(res.data!);

    html.Document dom = parse(result);
    var a = dom.body!.querySelector("a#img");
    String imgUrl = "http://pic.netbian.com/" + a!.firstChild!.attributes["src"]!;
    final info = dom.body!.querySelector("div.infor");

    final resolution = Resolution.parse(info!.children[1].children.first.text);
    final size = info.children[2].children.first.text;
    final updateTime = info.children[3].children.first.text;

    imgDetail.sizeStr = size;
    imgDetail.imgUrl = imgUrl;
    imgDetail.updateTimeStr = updateTime;
    imgDetail.resolution = resolution;
    print("主图片");
    print(imgDetail);
    var more = dom.body!.querySelector("ul.clearfix");
    final imgs = more!.children.map((item) {
      final imgTag = item.querySelector("img");
      final title = item.querySelector("a");
      final u = "http://pic.netbian.com/" + imgTag!.attributes["src"]!;
      var herf = title!.attributes["href"]!;
      var imgPage = herf;
      if (!herf.contains("http")) {
        imgPage = "http://pic.netbian.com/" + herf;
      }

      var subImg = ImgInfo(imgUrl: u, imgName: imgTag.attributes["alt"]!, imgPage: imgPage);
      print("subImg:" + subImg.toString());
      return subImg;
    }).toList();
    print("imgs:");
    print(imgs);
    imgDetail.moreImages = imgs;
    return imgDetail;
  }
}
