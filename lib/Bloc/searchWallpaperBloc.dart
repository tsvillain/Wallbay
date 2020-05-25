import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallbay/Bloc/wallpaperEvent.dart';
import 'package:wallbay/Bloc/wallpaperState.dart';
import 'package:wallbay/Model/wallpaper.dart';
import 'package:wallbay/const.dart';
import 'package:http/http.dart' as http;

class SearchWallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  List<Wallpaper> _searchWallpaper = List<Wallpaper>();

  @override
  WallpaperState get initialState => SearchWallpaperIsLoading();

  @override
  Stream<WallpaperState> mapEventToState(WallpaperEvent event) async* {
    if (event is SearchWallpaper) {
      yield SearchWallpaperIsLoading();
      try {
        var response = await http.get(
            Uri.encodeFull(searchEndPoint + event.string + perPageLimit),
            headers: {
              "Accept": "application/json",
              "Authorization": "$apiKey"
            });
        var data = jsonDecode(response.body)["photos"];
        _searchWallpaper = List<Wallpaper>();
        for (var i = 0; i < data.length; i++) {
          _searchWallpaper.add(Wallpaper.fromMap(data[i]));
        }
        yield SearchWallpaperIsLoaded(_searchWallpaper);
      } catch (_) {
        yield SearchWallpaperIsNotLoaded();
      }
    }
  }
}
