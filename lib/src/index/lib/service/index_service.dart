import 'dart:convert';

import 'package:http/http.dart';
import 'package:saoperolas/src/index/lib/model/cover.dart';

import '../../../constants.dart';

class IndexService {
  final Client _http;
  IndexService(this._http);

  Future<List<Cover>> getCoverPhotos() async {
    try {
      final response = await _http.get(baseUrl + "/products/background/");
      var clean = _extractData(response);
      return (clean as List)
          .map((cover) => Cover.fromJson(cover))
          .toList();
    } catch(e) {
      return [];
    }
  }
  dynamic _extractData(Response resp) => json.decode(resp.body);
}