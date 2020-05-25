import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallbay/Bloc/searchWallpaperBloc.dart';
import 'package:wallbay/Bloc/wallpaperEvent.dart';
import 'package:wallbay/Bloc/wallpaperState.dart';
import 'package:wallbay/Model/wallpaper.dart';
import 'package:wallbay/Screens/Detail.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int counter = 0;
  SearchWallpaperBloc _wallpaperBloc;
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Icon actionIcon = Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    _wallpaperBloc = BlocProvider.of<SearchWallpaperBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _wallpaperBloc
                    .add(SearchWallpaper(string: searchController.text));
              },
              icon: Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: _data(context),
    );
  }

  void openPage(Wallpaper wallpaper) {
    counter++;
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => Detail(
          wallpaper: wallpaper,
        ),
      ),
    );
  }

  void showAd(Wallpaper wallpaper) {
    //TODO add Ad
    counter = 0;
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => Detail(
          wallpaper: wallpaper,
        ),
      ),
    );
  }

  Widget _data(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width / 2);
    return BlocBuilder<SearchWallpaperBloc, WallpaperState>(
      builder: (BuildContext context, WallpaperState state) {
        if (state is SearchWallpaperNotSearched) {
          return Center(
            child: Text("Search Wallpaper"),
          );
        } else if (state is SearchWallpaperIsLoading) {
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
                    counter == 2
                        ? showAd(state.getSearchWallpaper[index])
                        : openPage(state.getSearchWallpaper[index]);
                  },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Hero(
                      tag: state.getSearchWallpaper[index].portrait,
                      child: FadeInImage.assetNetwork(
                        image: state.getSearchWallpaper[index].portrait,
                        fit: BoxFit.cover,
                        placeholder: "image/abstract.jpg",
                        imageScale: 1,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is SearchWallpaperIsNotLoaded) {
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
}
