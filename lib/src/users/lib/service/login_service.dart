import 'package:http/http.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';
import 'package:saoperolas/src/users/lib/model/user.dart';
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
      return null;
    }
  }

  Future<String> addToFavourites(int id, String token) async {
    try {
      final response = await _http.post(baseUrl + "/users/add-to-favs", headers: {'Authorization': 'Token ' + token}, body: jsonEncode({'id': id}));
      var clean = _extractData(response);
      return clean;
    } catch(e) {
      return "Erro ao conectar com o servidor";
    }
  }

  Future<String> removeFromFavourites(int id, String token) async {
    try {
      final response = await _http.post(baseUrl + "/users/remove-from-favs", headers: {'Authorization': 'Token ' + token}, body: jsonEncode({'id': id}));
      var clean = _extractData(response);
      return clean;
    } catch(e) {
      return "Erro ao conectar com o servidor";
    }
  }

  Future<List<Product>> getFavourites(String token) async {
    try {
      final response = await _http.get(baseUrl + "/users/get-favs", headers: {'Authorization': 'Token ' + token});
      var clean = _extractData(response);
      return (clean as List)
        .map((product) => Product.fromJson(product))
        .toList();
    } catch(e) {
      return [];
    }
  }

  Future<String> updateUserDetails(String token, String email, String first_name, String last_name, String country, String address, String zip, String city, String localidade, String cell) async {
    try {
      var bod = {};
      if(email != null) {
        bod['email'] = email;
      } if((first_name != null) && (first_name != "")) {
        bod['first_name'] = first_name;
      } if((last_name != null) && (last_name != "")) {
        bod['last_name'] = last_name;
      } if((country != null) && (country != "")) {
        bod['country'] = country;
      } if((address != null) && (address != "")) {
        bod['address'] = address;
      } if((zip != null) && (zip != "")) {
        bod['zip_code'] = zip;
      } if((city != null) && (zip != "")) {
        bod['city'] = city;
      } if((localidade != null) && (localidade != "")) {
        bod['localidade'] = localidade;
      } if((cell != null) && (cell != "")) {
        bod['cell_number'] = cell;
      }
      final response = await _http.post(baseUrl + "/users/update-infos", headers: {'Authorization': 'Token ' + token}, body: jsonEncode(bod));
      var clean = _extractData(response);
      return clean['error'];
    } catch(e) {
      return "There was an error connecting to our server, please try again";
    }
  }

  Future<User> getUserDetails(String token) async {
    try {
      final response = await _http.get(baseUrl + "/users/get-details", headers: {'Authorization': 'Token ' + token});
      var clean = _extractData(response);
      return User.fromJson(clean);
    } catch(e) {
      return null;
    }
  }
  
  dynamic _extractData(Response resp) => json.decode(resp.body);
}
