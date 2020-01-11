import 'dart:convert';

import 'package:http/http.dart';
import 'package:saoperolas/src/cart/lib/model/cart.dart';

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

  Future<Cart> getCartForUser(String token) async {
    try {
      final response = await _http.get(baseUrl + "/cart/get/", headers: {'Authorization': 'Token ' + token});
      var clean = _extractData(response);
      List products = 
      (clean['products'] as List)
        .map((product) => CartProduct.fromJson(product))
        .toList();
      return Cart(clean['id'], products, 3, clean['total_price']);
      return null;
    } catch(e) {
      print((e.toString()));
    }
  }
  
  dynamic _extractData(Response resp) => json.decode(resp.body);
}