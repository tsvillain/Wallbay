import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:wallbay/Screens/DailyNew.dart';
import 'package:wallbay/Screens/Search.dart';
import 'package:wallbay/Screens/Setting.dart';
import 'package:wallbay/Screens/Trending.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage(this.title);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => Search()));
          },
          elevation: 3.0,
        ),
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Setting()));
              },
            )
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text("Editor's Choice"),
              ),
              Tab(
                child: Text("Cateogry"),
              ),
            ],
          ),
        ),
        body: DoubleBackToCloseApp(
          child: TabBarView(
            children: <Widget>[
              EditorChoice(),
              Trending(
                  "https://api.unsplash.com/search/photos/?client_id=2eeaf188bc7eb96754597cdc8094efe5f8ee3f5e58cfe9d2ff4fcb5df176347b&per_page=50&query=wallpapers"),
            ],
          ),
          snackBar: const SnackBar(
            content: Text('Press Again To Leave'),
          ),
        ),
      ),
    );
  }
}
