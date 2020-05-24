import 'package:flutter/cupertino.dart';

abstract class WallpaperEvent {}

class GetAllWallpaper extends WallpaperEvent {}

class SearchWallpaper extends WallpaperEvent {
  final String string;
  SearchWallpaper({@required this.string});
}
