import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:wallbay/Bloc/wallpaperBloc.dart';
import 'package:wallbay/Bloc/wallpaperEvent.dart';
import 'package:wallbay/Bloc/wallpaperState.dart';
import 'package:wallbay/Screens/Detail.dart';

class EditorChoice extends StatefulWidget {
  @override
  _EditorChoiceState createState() => _EditorChoiceState();
}

class _EditorChoiceState extends State<EditorChoice>
    with AutomaticKeepAliveClientMixin {
  WallpaperBloc _wallpaperBloc;

  @override
  Widget build(BuildContext context) {
    _wallpaperBloc = BlocProvider.of<WallpaperBloc>(context);
    _wallpaperBloc.add(GetAllWallpaper());
    super.build(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width / 2);
    return BlocBuilder<WallpaperBloc, WallpaperState>(
      builder: (BuildContext context, state) {
        if (state is WallpaperIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WallpaperIsLoaded) {
          return GridView.builder(
            padding: EdgeInsets.all(5),
            itemCount: state.getWallpaper.length,
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
                                  wallpaper: state.getWallpaper[index],
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
                      image: NetworkImage(state.getWallpaper[index].portrait),
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
          return Text("WentWorng.");
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    super.dispose();
    _wallpaperBloc.close();
  }
}
