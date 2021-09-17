import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_work/4KImage/model.dart';
import 'package:gbk_codec/gbk_codec.dart';

const recentSuggest = [
  "DVA",
  "美食",
];

class SearchBarDelegate extends SearchDelegate<String> {
  List<ImgInfo> items = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), onPressed: () => close(context, "result"));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<ImgInfo>>(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<List<ImgInfo>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
            case ConnectionState.none:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              return Container(
                child: Center(
                  child: Text("直接用他们的链接搜索的话一直返回没有搜索到相关的内容，但是网页是可以的，可能需要自定义请求头,写了一些请求头还是不行"),
                ),
              );
          }
        });
  }

  Future<List<ImgInfo>> _getData() async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var data = {"keyboard": query, "tempid": 1, "tbname": "photo", "show": "title", "submit": ""};
    print("请求的数据");
    print(data);
    var url = "http://pic.netbian.com/e/search/index.php";
    dio.options.responseType = ResponseType.bytes;

    var option = Options();
    option.headers = {
      HttpHeaders.acceptHeader: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      HttpHeaders.acceptEncodingHeader: "gzip, deflate",
      HttpHeaders.cacheControlHeader: "max-age=0",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.userAgentHeader: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36 Edg/79.0.309.54"
    };

    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded").toString();
    print(dio.options.contentType);
    var res = await dio.post<List<int>>(url, queryParameters: data, options: option);

    var location = res.headers.value("Location");
    print("header");
    print("location");
    print(location);
    print("statuscode");
    print(res.statusCode);
    print(res.headers);

    final result = gbk_bytes.decode(res.data!);
    print(result);
    return [ImgInfo()];
    //这样直接写不会返回搜索的所需要的东西，可能需要自定义请求头,写了一些请求头还是不行
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final suggestionList = query.isEmpty
    //     ? recentSuggest
    //     : searchList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) => ListTile(
              title: RichText(
                  text: TextSpan(
                text: recentSuggest[index],
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
            ));
  }
}
