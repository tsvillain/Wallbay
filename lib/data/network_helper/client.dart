import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wallbay/data/network_helper/endpoint.dart';

final networkHelper =
    Provider.autoDispose((ref) => NetworkClient(http.Client()));

class NetworkClient {
  final http.Client _client;
  NetworkClient(this._client);

  // GET
  Future<http.Response> get(
    String url, {
    Map<String, String> headers,
  }) async {
    try {
      final http.Response response =
          await _client.get(Uri.parse(url), headers: headers);
      return response;
    } catch (e) {
      throwError(method: 'GET', error: e.toString(), endPoint: url);
    }
  }

  // POST
  Future<http.Response> post(
    String url, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    try {
      final http.Response response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throwError(method: 'POST', error: e.toString(), endPoint: url);
    }
  }

  Map<String, dynamic> defaultAuthHeader() {
    return {
      "Accept": "application/json",
      "Authorization": Endpoints.apiKey,
    };
  }

  void throwError({
    @required String method,
    @required String error,
    @required String endPoint,
  }) {
    debugPrint("http~[$method] : Failed for [$endPoint] with error: $error");
  }
}
