import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbay/data/repositories/wallpaper_repo.dart';
import 'package:wallbay/model/wallpaper.dart';
import 'core/default_noitifer.dart';

class WallpaperProvider extends DefaultChangeNotifier {
  final WallpaperRepo _wallpaperRepo;
  WallpaperProvider(Reader read) : _wallpaperRepo = read(wallpaperRepo);
  List<Wallpaper> _wallpaper = [];
  List<Wallpaper> get getWallpapers => _wallpaper;
  List<Wallpaper> _searchWallpaper = [];
  List<Wallpaper> get getSearchWallpapers => _searchWallpaper;
  List<Wallpaper> _categoryWallpaper = [];
  List<Wallpaper> get getCategoryWallpapers => _categoryWallpaper;

  Future fetchWallpaper() async {
    try {
      toggleLoading(true);
      _wallpaper = [];
      _wallpaper = await _wallpaperRepo.getWallpapers();
    } catch (e) {
      debugPrint('WallpaperProvider: ${e.toString()}');
    } finally {
      toggleLoading(false);
    }
  }

  Future searchWallpaper({@required String params}) async {
    try {
      toggleLoading(true);
      _searchWallpaper = [];
      _searchWallpaper = await _wallpaperRepo.searchWallpapers(params: params);
    } catch (e) {
      debugPrint('WallpaperProvider: ${e.toString()}');
    } finally {
      toggleLoading(false);
    }
  }

  Future categoryWallpaper({@required String categoryName}) async {
    try {
      toggleLoading(true);
      _categoryWallpaper = [];
      _categoryWallpaper =
          await _wallpaperRepo.searchWallpapers(params: categoryName);
    } catch (e) {
      debugPrint('WallpaperProvider: ${e.toString()}');
    } finally {
      toggleLoading(false);
    }
  }
}
