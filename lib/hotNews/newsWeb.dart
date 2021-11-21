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
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

//发现一个严重的问题导致这个项目失败，这个网站的链接应该是加密的，然后应该是调用内部js解密，再生成url，目前这个问题无解。
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catInfo.name!),
      ),
      body: WebView(
        initialUrl: widget.catInfo.yutangUrl,
      ),
    );
  }
}
