import 'package:http/http.dart';
import 'dart:convert';

import '../../../constants.dart';


class LoginService {
  final Client _http;
  LoginService(this._http);

  static final _headers = {'Content-Type': 'application/json'};

  Future<dynamic> login(String email, String password) async {
    try {
      final response = await _http.post(baseUrl + '/users/get-token', body: jsonEncode({'email': email, 'password': password}));
      return _extractData(response);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> signup(String email, String password1, String password2, String firstName, String lastName, String country, String address, String zip, String city, String localidade, String error, int cell) async {
    try {
      final response = await _http.post(baseUrl + '/users/signup', body: jsonEncode({
        'email': email,
        'password1': password1,
        'first_name': firstName,
        'last_name': lastName,
        'address': address,
        'city': city,
        'localidade': localidade,
        'zip_code': zip,
        'country': country,
        'cell_number': cell
      }));
      return _extractData(response);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  dynamic _extractData(Response resp) => json.decode(resp.body);
}
