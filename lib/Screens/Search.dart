import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

import 'package:wallbay/Screens/Detail.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List wall;
  bool isLoading = true;
  bool load = false;
  TextEditingController searchController = TextEditingController();
  String get search => searchController.text;
  searchMethod() async {
    String url =
        "https://api.unsplash.com/search/photos/?client_id=2eeaf188bc7eb96754597cdc8094efe5f8ee3f5e58cfe9d2ff4fcb5df176347b&per_page=50&query=" +
            search;
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    List data = jsonDecode(response.body)['results'];
    setState(() {
      wall = data;
      isLoading = false;
    });
  }

  final FocusNode _focusNode = FocusNode();
  Icon actionIcon = Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          focusNode: _focusNode,
          controller: searchController,
          decoration: InputDecoration(hintText: "Search.."),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(FocusNode());
            load = true;
            searchMethod();
          },
        ),
        actions: <Widget>[
          IconButton(
            alignment: Alignment.centerRight,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              load = true;
              searchMethod();
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: _data(context),
    );
  }

  Widget _data(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width / 2);
    return Container(
      child: load == false
          ? Center(
              child: Text(""),
            )
          : Center(
              child: isLoading
                  ? SpinKitWanderingCubes(
                      color: Theme.of(context).accentColor,
                      size: 50.0,
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(5),
                      itemCount: wall.length == null ? 0 : wall.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: (itemWidth / itemHeight)),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     CupertinoPageRoute(
                              //         builder: (context) => Detail(
                              //               wall[index]['user']['name'],
                              //               wall[index]['user']['profile_image']
                              //                   ['large'],
                              //               'Unsplash',
                              //               wall[index]['urls']['regular'],
                              //               wall[index]['user']
                              //                   ['portfolio_url'],
                              //               wall[index]['user']['bio'],
                              //               wall[index]['user']['location'],
                              //               wall[index]['user']['links']
                              //                   ['html'],
                              //               wall[index]['urls']['raw'],
                              //             )));
                            },
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Color(
                                      (math.Random().nextDouble() * 0xFFFFFF)
                                              .toInt() <<
                                          0)
                                  .withOpacity(1.0),
                              child: Image(
                                image:
                                    NetworkImage(wall[index]['urls']['small']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
