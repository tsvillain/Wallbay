import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallbay/Bloc/wallpaperEvent.dart';
import 'package:wallbay/Bloc/wallpaperState.dart';
import 'package:http/http.dart' as http;
import 'package:wallbay/Model/wallpaper.dart';
import 'package:wallbay/const.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  @override
  get initialState => WallpaperIsLoading();
  List<Wallpaper> _wallpaper = List<Wallpaper>();

  @override
  Stream<WallpaperState> mapEventToState(WallpaperEvent event) async* {
    if (event is GetAllWallpaper) {
      yield WallpaperIsLoading();
      try {
        var response = await http
            .get(Uri.encodeFull(editorChoiceEndPoint + perPageLimit), headers: {
          "Accept": "application/json",
          "Authorization": "$apiKey"
        });
        var data = jsonDecode(response.body)["photos"];
        _wallpaper = List<Wallpaper>();
        for (var i = 0; i < data.length; i++) {
          _wallpaper.add(Wallpaper.fromMap(data[i]));
        }
        yield WallpaperIsLoaded(_wallpaper);
      } catch (_) {
        yield WallpaperIsNotLoaded();
      }
    }
  }
}
