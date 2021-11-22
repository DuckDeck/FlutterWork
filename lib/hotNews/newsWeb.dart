import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_work/com/Base.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebPage extends StatefulWidget {
  final CatInfo catInfo;
  const NewsWebPage({required this.catInfo, Key? key}) : super(key: key);

  @override
  _NewsWebPageState createState() => _NewsWebPageState();
}

class _NewsWebPageState extends State<NewsWebPage> {
  late WebViewController webViewController;
  late var title = widget.catInfo.name!;
  @override
  void initState() {
    super.initState();
    print("加载的URL是${widget.catInfo.yutangUrl}");
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

//发现一个严重的问题导致这个项目失败，这个网站的链接应该是加密的，然后应该是调用内部js解密，再生成url，目前这个问题无解。
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: WebView(
            //真坑，这个默认不让用js导致这个网站打不开
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (con) {
              webViewController = con;
            },
            onPageStarted: (start) {
              print(start);
            },
            onPageFinished: (finish) {
              print(finish);

              webViewController.getTitle().then((value) => {
                    if (value != null)
                      {
                        setState(() {
                          title = value;
                        })
                      }
                  });
            },
            onProgress: (index) {
              print("WebView加载$index");
            },
            onWebResourceError: (error) {
              print(error.description);
            },
            initialUrl: widget.catInfo.yutangUrl,
          ),
        ),
        onWillPop: () async {
          webViewController.canGoBack().then((value) => {
                if (value)
                  {webViewController.goBack()}
                else
                  {Navigator.of(context).pop()}
              });
          return false;
        });
  }
}
