import 'package:http/http.dart';
import 'dart:convert';

import '../../../constants.dart';


class LoginService {
  final Client _http;
  LoginService(this._http);

  static final _headers = {'Content-Type': 'application/json'};

  Future<String> login(String email, String password) async {
    try {
      final response = await _http.post(baseUrl + "/users/get-token", body: jsonEncode({"email": email, "password": password}));
      return response.body;
    }catch (e) {
      return null;
    }
  }
  dynamic _extractData(Response resp) => json.decode(resp.body);
}
