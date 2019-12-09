import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:wallbay/Screens/Detail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DailyNew extends StatefulWidget {
  final String api;
  DailyNew(this.api);
  @override
  _DailyNewState createState() => _DailyNewState();
}

class _DailyNewState extends State<DailyNew>
    with AutomaticKeepAliveClientMixin {
  int count = 0;
  List wall;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _getWallbay();
  }

  checkNetwork() async {
    return await DataConnectionChecker().connectionStatus;
  }

  Future _getWallbay() async {
    DataConnectionStatus status = await checkNetwork();
    if (status == DataConnectionStatus.connected) {
      var response = await http.get(Uri.encodeFull(widget.api),
          headers: {"Accept": "application/json"});
      List data = jsonDecode(response.body);
      setState(() {
        wall = data;
        isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("No Internet"),
          content: Text("Check your network connection"),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () => exit(0),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width / 2);
    return Container(
      child: Center(
        child: isLoading
            ? SpinKitFadingCube(
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
                        count++;
                        print(count);
                        if (count == 5) {
                          count = 0;
                        }
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => Detail(
                                      wall[index]['user']['name'],
                                      wall[index]['user']['profile_image']
                                          ['large'],
                                      'Unsplash',
                                      wall[index]['urls']['regular'],
                                      wall[index]['user']['portfolio_url'],
                                      wall[index]['user']['bio'],
                                      wall[index]['user']['location'],
                                      wall[index]['user']['links']['html'],
                                      wall[index]['urls']['raw'],
                                    )));
                      },
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt() <<
                                0)
                            .withOpacity(1.0),
                        child: Image(
                          image: NetworkImage(wall[index]['urls']['small']),
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

  @override
  bool get wantKeepAlive => true;
}
