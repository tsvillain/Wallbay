import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallbay/Bloc/wallpaperEvent.dart';
import 'package:wallbay/Bloc/wallpaperState.dart';
import 'package:wallbay/Model/wallpaper.dart';
import 'package:http/http.dart' as http;
import 'package:wallbay/const.dart';

class CategoryWallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  List<Wallpaper> _categoryWallpaper = List<Wallpaper>();
  @override
  WallpaperState get initialState => CategoryWallpaperIsLoading();

  @override
  Stream<WallpaperState> mapEventToState(WallpaperEvent event) async* {
    if (event is CategoryWallpaper) {
      yield CategoryWallpaperIsLoading();
      try {
        var response = await http.get(
            Uri.encodeFull(searchEndPoint + event.category + perPageLimit),
            headers: {
              "Accept": "application/json",
              "Authorization": "$apiKey"
            });
        var data = jsonDecode(response.body)["photos"];
        _categoryWallpaper = List<Wallpaper>();
        for (var i = 0; i < data.length; i++) {
          _categoryWallpaper.add(Wallpaper.fromMap(data[i]));
        }
        yield CategoryWallpaperIsLoaded(_categoryWallpaper);
      } catch (_) {
        yield CategoryWallpaperIsNotLoaded();
      }
    }
  }
}
