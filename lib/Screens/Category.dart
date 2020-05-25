import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallbay/Bloc/categoryWallpaperBloc.dart';
import 'package:wallbay/Bloc/wallpaperEvent.dart';
import 'package:wallbay/Bloc/wallpaperState.dart';
import 'package:wallbay/Screens/Detail.dart';

class Category extends StatefulWidget {
  final String category;
  Category({@required this.category});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  CategoryWallpaperBloc categoryWallpaperBloc;

  @override
  Widget build(BuildContext context) {
    categoryWallpaperBloc = BlocProvider.of<CategoryWallpaperBloc>(context);
    categoryWallpaperBloc.add(CategoryWallpaper(category: widget.category));
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width / 2);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget.category,
          style: TextStyle(fontFamily: 'Raleway'),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CategoryWallpaperBloc, WallpaperState>(
        builder: (BuildContext context, state) {
          if (state is CategoryWallpaperIsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CategoryWallpaperIsLoaded) {
            return GridView.builder(
              padding: EdgeInsets.all(5),
              itemCount: state.getCategoryWallpaper.length,
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
                                    wallpaper:
                                        state.getCategoryWallpaper[index],
                                  )));
                    },
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Hero(
                        tag: state.getCategoryWallpaper[index].portrait,
                        child: FadeInImage.assetNetwork(
                          image: state.getCategoryWallpaper[index].portrait,
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
          } else if (state is CategoryWallpaperIsNotLoaded) {
            return Center(
              child: Text("Error Loading Wallpapers."),
            );
          } else {
            return Text("WentWorng.");
          }
        },
      ),
    );
  }
}
