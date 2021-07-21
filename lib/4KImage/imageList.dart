import 'dart:ffi';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'model.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as html;
import 'package:flutter/cupertino.dart';
import 'imageDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';

const recentSuggest = [
  "DVA",
  "美食",
];

class MainImageList extends StatefulWidget {
  @override
  _MainImageListState createState() => _MainImageListState();
}

class _MainImageListState extends State<MainImageList>
    with SingleTickerProviderStateMixin {
  var titles = [
    CatInfo(name: "最新", urlSegment: "new"),
    CatInfo(name: "风景", urlSegment: "4kfengjing"),
    CatInfo(name: "美女", urlSegment: "4kmeinv"),
    CatInfo(name: "游戏", urlSegment: "4kyouxi"),
    CatInfo(name: "动漫", urlSegment: "4kdongman"),
    CatInfo(name: "影视", urlSegment: "4kyingshi"),
    CatInfo(name: "明星", urlSegment: "4kmingxing"),
    CatInfo(name: "汽车", urlSegment: "4kqiche"),
    CatInfo(name: "动物", urlSegment: "4kdongwu"),
    CatInfo(name: "人物", urlSegment: "4krenwu"),
    CatInfo(name: "美食", urlSegment: "4kmeishi"),
    CatInfo(name: "宗教", urlSegment: "4kzongjiao"),
    CatInfo(name: "背景", urlSegment: "4kbeijing"),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 13,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("美图"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print("开始搜索");
                showSearch(context: context, delegate: SearchBarDelegate());
              },
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: titles.map((title) {
              return Tab(
                text: title.name,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
            children: titles.map((img) {
          return ScrollImagesPage(
            imgCat: img,
          );
        }).toList()),
      ),
    );
  }
}

class ScrollImagesPage extends StatefulWidget {
  ScrollImagesPage({this.imgCat});
  final CatInfo? imgCat;
  @override
  _ScrollImagesPageState createState() => _ScrollImagesPageState();
}

class _ScrollImagesPageState extends State<ScrollImagesPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int _page = 0;
  int _eLoading = 0; //0不显示 1 正在请求 2 没有更多数据
  Future<void>? items;
  List<ImgInfo> photos = [];
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    items = _initData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("到最下在开始圆形更多");
        _addMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: items,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              {
                return SingleChildScrollView(
                    child: SkeletonGridLoader(
                  builder: Card(
                    color: Colors.transparent,
                    child: GridTile(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 120,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 150,
                            height: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  items: 10,
                  itemsPerRow: 2,
                  period: Duration(seconds: 2),
                  highlightColor: Colors.lightBlue[300]!,
                  direction: SkeletonDirection.ltr,
                  childAspectRatio: 1,
                ));
              }
            case ConnectionState.done:
              {
                print("请求完成");
                print(photos.length);

                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshData,
                  child: Container(
                    color: Colors.grey[100],
                    child: StaggeredGridView.countBuilder(
                      controller: _scrollController,
                      itemCount: photos.length,
                      primary: false,
                      crossAxisCount: 4,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemBuilder: (context, index) => ImageCell(
                        imageInfo: photos[index],
                      ),
                      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                    ),
                  ),
                );
              }
          }
        });
  }

  Future _initData() async {
    photos = await _getData(false);
  }

  Future _refreshData() async {
    _page = 0;
    final ps = await _getData(false);
    setState(() {
      photos = ps;
    });
  }

  Future _addMoreData() async {
    _page++;
    final ps = await _getData(true);
    setState(() {
      photos += ps;
    });
  }

  Future<List<ImgInfo>> _getData(bool _deAdd) async {
    print("开始请求，类型是${widget.imgCat!.name}");
    var index = "";
    if (_page > 0) {
      index = "index_${_page + 1}.html";
    }

    var url = "http://pic.netbian.com/${widget.imgCat!.urlSegment}/$index";
    print(url);
    Dio dio = Dio();
    dio.options.responseType = ResponseType.bytes;
    Response<List<int>> res = await dio.get<List<int>>(url);
    final result = gbk_bytes.decode(res.data!);

    html.Document dom = parse(result);
    var uls = dom.body!.querySelector("ul.clearfix");

    return uls!.children.map((img) {
      final tag = img.firstChild;
      final imgPage = "http://pic.netbian.com/" + tag!.attributes["href"]!;
      final imgUrl =
          "http://pic.netbian.com/" + tag.firstChild!.attributes["src"]!;
      final imgName = tag.firstChild!.attributes["alt"];
      return ImgInfo(imgName: imgName!, imgPage: imgPage, imgUrl: imgUrl);
    }).toList();
  }
}

class ImageCell extends StatelessWidget {
  ImageCell({required this.imageInfo});
  ImgInfo imageInfo;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
          child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(minHeight: 120),
              child: CachedNetworkImage(
                imageUrl: imageInfo.imgUrl,
                progressIndicatorBuilder: (context, url, progress) => Center(
                    child: Container(
                  width: 50,
                  height: 50,
                  child: Image.asset('images/spin.gif'),
                )),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(imageInfo.imgName),
            )
          ],
        ),
      )),
      onTap: () {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (BuildContext context) {
          return ImageDetail(
            imgInfo: imageInfo,
          );
        }));
      },
    );
  }
}

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
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () => close(context, "result"));
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
                  child: Text(
                      "直接用他们的链接搜索的话一直返回没有搜索到相关的内容，但是网页是可以的，可能需要自定义请求头,写了一些请求头还是不行"),
                ),
              );
          }
        });
  }

  Future<List<ImgInfo>> _getData() async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var data = {
      "keyboard": query,
      "tempid": 1,
      "tbname": "photo",
      "show": "title",
      "submit": ""
    };
    print("请求的数据");
    print(data);
    var url = "http://pic.netbian.com/e/search/index.php";
    dio.options.responseType = ResponseType.bytes;

    var option = Options();
    option.headers = {
      HttpHeaders.acceptHeader:
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      HttpHeaders.acceptEncodingHeader: "gzip, deflate",
      HttpHeaders.cacheControlHeader: "max-age=0",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.userAgentHeader:
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36 Edg/79.0.309.54"
    };

    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded").toString();
    print(dio.options.contentType);
    var res =
        await dio.post<List<int>>(url, queryParameters: data, options: option);

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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
            ));
  }
}
