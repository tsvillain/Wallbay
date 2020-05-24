import 'package:equatable/equatable.dart';
import 'package:wallbay/Model/wallpaper.dart';

class WallpaperState extends Equatable {
  @override
  List<Object> get props => [];
}

class WallpaperIsLoading extends WallpaperState {}

class WallpaperIsLoaded extends WallpaperState {
  final List<Wallpaper> _wallpaper;
  WallpaperIsLoaded(this._wallpaper);
  List<Wallpaper> get getWallpaper => _wallpaper;
  @override
  List<Object> get props => [_wallpaper];
}

class WallpaperIsNotLoaded extends WallpaperState {}
