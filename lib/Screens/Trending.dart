import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Trending extends StatefulWidget {
  final String api;
  Trending(this.api);
  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Text("TODO add Category");
  }

  @override
  bool get wantKeepAlive => true;
}
