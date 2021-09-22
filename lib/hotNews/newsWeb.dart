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

  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
    );
  }
}
