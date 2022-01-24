import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbay/model/wallpaper.dart';

import 'wallpaper_repo_impl.dart';

final wallpaperRepo =
    Provider.autoDispose((ref) => WallpaperRepoImpl(ref.read));
mixin WallpaperRepo {
  Future<List<Wallpaper>> getWallpapers();
  Future<List<Wallpaper>> searchWallpapers({@required String params});
}
