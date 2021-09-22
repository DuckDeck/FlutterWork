import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebPage extends StatefulWidget {
  final String url;
  final String title;
  final bool isLocalUrl;

  const NewsWebPage({required this.url, this.isLocalUrl = false, this.title = "", Key? key}) : super(key: key);

  @override
  _NewsWebPageState createState() => _NewsWebPageState();
}

class _NewsWebPageState extends State<NewsWebPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

//发现一个严重的问题导致这个项目失败，这个网站的链接应该是加密的，然后应该是调用内部js解密，再生成url，目前这个问题无解。
  Widget build(BuildContext context) {
    print(widget.url);
    return WebView(
      initialUrl: widget.url,
    );
  }
}
