import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wallbay/Screens/Search.dart';
import 'package:wallbay/Screens/Setting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbay/presentation/screens/category/category_list.dart';
import 'package:wallbay/presentation/screens/home/home_view_model.dart';
import '../editor/editor_choice.dart';

class MyHomePage extends ConsumerStatefulWidget {
  final String title;
  const MyHomePage(this.title);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(homeViewProvider).init();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homeViewProvider);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Raleway',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => Setting()));
            },
          )
        ],
      ),
      body: PageView.builder(
        onPageChanged: viewModel.updateIndex,
        controller: viewModel.controller,
        itemBuilder: (BuildContext context, int index) {
          return getScreen(index);
        },
        itemCount: viewModel.tabs.length,
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: -10,
                        blurRadius: 60,
                        color: Colors.black.withOpacity(.20),
                        offset: Offset(0, 15))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                child: GNav(
                    tabs: viewModel.tabs,
                    selectedIndex: viewModel.selectedIndex,
                    onTabChange: (index) {
                      viewModel.updateIndex(index);
                      viewModel.controller.jumpToPage(index);
                    }),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 20, top: 20, bottom: 20),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Search()));
                },
                elevation: 3.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

getScreen(int selectedIndex) {
  if (selectedIndex == 0) {
    return EditorChoice();
  } else if (selectedIndex == 1) {
    return CategoryList();
  }
}
