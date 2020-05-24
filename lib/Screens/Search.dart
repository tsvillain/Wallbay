import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:wallbay/Bloc/wallpaperBloc.dart';
import 'package:wallbay/Bloc/wallpaperEvent.dart';
import 'package:wallbay/Bloc/wallpaperState.dart';
import 'package:wallbay/Screens/Detail.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}
//bug in search

class _SearchState extends State<Search> {
  WallpaperBloc _wallpaperBloc;
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Icon actionIcon = Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    _wallpaperBloc = BlocProvider.of<WallpaperBloc>(context);
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
            _wallpaperBloc.add(SearchWallpaper(string: searchController.text));
          },
        ),
        actions: <Widget>[
          IconButton(
            alignment: Alignment.centerRight,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _wallpaperBloc
                  .add(SearchWallpaper(string: searchController.text));
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
    return BlocBuilder<WallpaperBloc, WallpaperState>(
      builder: (BuildContext context, WallpaperState state) {
        if (state is WallpaperNotSearched) {
          return Center(
            child: Text("Search Wallpaper"),
          );
        } else if (state is WallpaperIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchWallpaperIsLoaded) {
          return GridView.builder(
            padding: EdgeInsets.all(5),
            itemCount: state.getSearchWallpaper.length,
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
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => Detail(
                                  wallpaper: state.getSearchWallpaper[index],
                                )));
                  },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Color(
                            (math.Random().nextDouble() * 0xFFFFFF).toInt() <<
                                0)
                        .withOpacity(1.0),
                    child: Image(
                      image: NetworkImage(
                          state.getSearchWallpaper[index].portrait),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is WallpaperIsNotLoaded) {
          return Center(
            child: Text("Error Loading Wallpapers."),
          );
        } else {
          return Center(
            child: Text("Search Wallpaper"),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _wallpaperBloc.close();
  }
}
