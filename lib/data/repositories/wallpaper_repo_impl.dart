import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallbay/data/network_helper/client.dart';
import 'package:wallbay/data/network_helper/endpoint.dart';
import 'package:wallbay/data/repositories/wallpaper_repo.dart';
import 'package:wallbay/model/wallpaper.dart';

class WallpaperRepoImpl implements WallpaperRepo {
  final NetworkClient _client;
  WallpaperRepoImpl(Reader read) : _client = read(networkHelper);
  @override
  Future<List<Wallpaper>> getWallpapers() async {
    List<Wallpaper> _wallpapers = [];
    final _res = await _client.get(
      '${Endpoints.editorChoiceEndPoint}${Endpoints.perPageLimit}',
      headers: _client.defaultAuthHeader(),
    );
    if (_res != null) {
      final _data = jsonDecode(_res.body)["photos"];
      for (var i = 0; i < _data.length; i++) {
        _wallpapers.add(Wallpaper.fromMap(_data[i]));
      }
    }
    return _wallpapers;
  }

  @override
  Future<List<Wallpaper>> searchWallpapers({String params}) async {
    List<Wallpaper> _wallpapers = [];
    final _res = await _client.get(
      '${Endpoints.searchEndPoint}$params${Endpoints.perPageLimit}',
      headers: _client.defaultAuthHeader(),
    );
    if (_res != null) {
      final _data = jsonDecode(_res.body)["photos"];
      for (var i = 0; i < _data.length; i++) {
        _wallpapers.add(Wallpaper.fromMap(_data[i]));
      }
    }
    return _wallpapers;
  }
}
