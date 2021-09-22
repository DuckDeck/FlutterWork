import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_work/4KImage/imageSearch.dart';
import 'package:flutter_work/HotNews/newsWeb.dart';
import 'package:flutter_work/hotNews/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:flutter_work/com/Base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotNewsList extends StatefulWidget {
  @override
  _HotNewsListState createState() => _HotNewsListState();
}

class _HotNewsListState extends State<HotNewsList> with SingleTickerProviderStateMixin {
  var titles = [
    CatInfo(name: "鱼塘热榜", urlSegment: "1065", iconUrl: "https://img.printf520.com/鱼.png"),
    CatInfo(name: "虎扑热榜", urlSegment: "2", iconUrl: "https://img.printf520.com/img/151.png"),
    CatInfo(name: "NGA热榜", urlSegment: "106", iconUrl: "https://img.printf520.com/img/nga.png"),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: titles.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("鱼塘热榜"),
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

class _ScrollImagesPageState extends State<ScrollImagesPage> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  int _page = 1;
  int _eLoading = 0; //0不显示 1 正在请求 2 没有更多数据
  Future<void>? items;
  @override
  bool get wantKeepAlive => true;
  List<NewsInfo> arrNews = [];
  @override
  void initState() {
    super.initState();
    items = _initData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
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
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 100,
                            height: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  items: 10,
                  itemsPerRow: 1,
                  period: Duration(seconds: 2),
                  highlightColor: Colors.lightBlue[300]!,
                  direction: SkeletonDirection.ltr,
                  childAspectRatio: 1,
                ));
              }
            case ConnectionState.done:
              {
                print("请求完成");
                print(arrNews.length);
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshData,
                  child: Container(
                    color: Colors.grey[100],
                    child: StaggeredGridView.countBuilder(
                      controller: _scrollController,
                      itemCount: arrNews.length,
                      primary: false,
                      crossAxisCount: 1,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemBuilder: (context, index) => NewsCell(
                        news: arrNews[index],
                      ),
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    ),
                  ),
                );
              }
          }
        });
  }

  Future _initData() async {
    arrNews = await _getData(false);
  }

  Future _refreshData() async {
    _page = 0;
    final ps = await _getData(false);
    setState(() {
      arrNews = ps;
    });
  }

  Future _addMoreData() async {
    _page++;
    final ps = await _getData(true);
    setState(() {
      arrNews += ps;
    });
  }

  Future<List<NewsInfo>> _getData(bool _deAdd) async {
    print("开始请求，类型是${widget.imgCat!.name}");

    var url = "https://api.tophub.fun/v2/GetAllInfoGzip?id=${this.widget.imgCat!.urlSegment}&page=$_page&type=pc";
    print(url);
    Dio dio = Dio();
    Response res = await dio.get(url);
    List<NewsInfo> nn = <NewsInfo>[];

    Map<String, dynamic> data = res.data;
    if (data["Code"] as int != 0) {
      Fluttertoast.showToast(msg: data["Message"] as String);
      return nn;
    }

    List<dynamic> items = data["Data"]["data"];
    print("--------有${items.length}条数据----------");
    for (var item in items) {
      var n = NewsInfo();
      n.title = item["Title"];
      n.source = item["Url"];
      n.newsImg = item["imgUrl"];
      n.updateTime = item["CreateTime"] as int;
      if (item["icon"] != null && item["type"] != null) {
        n.newsCat = CatInfo(iconUrl: item["icon"], name: item["type"]);
      }
      if (item["hotDesc"] != null) {
        n.hotDesc = item["hotDesc"];
      }
      nn.add(n);
    }
    print("--------获取到${nn.length}条数据----------");
    return nn;
  }
}

class NewsCell extends StatelessWidget {
  NewsCell({required this.news});
  final NewsInfo news;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
          child: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Visibility(
              visible: news.newsImg.isNotEmpty,
              child: Container(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: news.newsImg,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                      child: Container(
                    width: 50,
                    height: 50,
                    child: Image.asset('images/spin.gif'),
                  )),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Container(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    news.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                news.newsCat == null
                    ? Container()
                    : Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            child: CachedNetworkImage(imageUrl: news.newsCat!.iconUrl!),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            news.newsCat!.name!,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          news.hotDesc.isEmpty
                              ? Container()
                              : Text(news.hotDesc,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(news.releaseTime)
                        ],
                      )
              ],
            )))
          ],
        ),
      )),
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) {
          return NewsWebPage(url: news.source);
        }));
      },
    );
  }
}
