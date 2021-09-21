import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_work/five/main.dart';
import 'package:flutter_work/4KImage/imageList.dart';
import 'package:flutter_work/hotNews/main.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Work',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => HomePage(),
        '/five': (BuildContext context) => FiveStrokePage(),
        '/4kimage': (BuildContext context) => MainImageList(),
        '/news': (BuildContext context) => HotNewsList(),
      },
    );
  }
}

const items = ["五笔反查", "4K图片", "鱼塘热榜"];

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Work Projects"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              gotoPage(index, context);
            },
            child: ListTile(
              title: Text(items[index]),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }

  void gotoPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed("/five");
        break;
      case 1:
        Navigator.of(context).pushNamed("/4kimage");
        break;
      case 2:
        Navigator.of(context).pushNamed("/news");
        break;
    }
  }
}
