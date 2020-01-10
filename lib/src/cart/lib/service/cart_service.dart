import 'dart:convert';

import 'package:http/http.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';

import '../../../constants.dart';

class CartService {
  final Client _http;
  CartService(this._http);


  Future<String> addToCart(int id, String token) async {
    try {
      final response = await _http.post(baseUrl + "/cart/add/", body: jsonEncode({'id': id}), headers: {'Authorization': 'Token ' + token});
      return _extractData(response)['error'];
    } catch(e) {
      return "ERROR";
    }
  }
  
  dynamic _extractData(Response resp) => json.decode(resp.body);
}