import 'package:wallbay/Model/wallpaper.dart';

abstract class WallpaperState {}

class WallpaperNotSearched extends WallpaperState {}

class WallpaperIsLoading extends WallpaperState {}

class WallpaperIsLoaded extends WallpaperState {
  final List<Wallpaper> _wallpaper;
  WallpaperIsLoaded(this._wallpaper);
  List<Wallpaper> get getWallpaper => _wallpaper;
}

class SearchWallpaperIsLoaded extends WallpaperState {
  final List<Wallpaper> _wallpaper;
  SearchWallpaperIsLoaded(this._wallpaper);
  List<Wallpaper> get getSearchWallpaper => _wallpaper;
}

class WallpaperIsNotLoaded extends WallpaperState {}
