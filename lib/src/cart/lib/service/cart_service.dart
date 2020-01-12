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
      return Cart(clean['id'], products, shipping_cost, clean['total_price']);
      return null;
    } catch(e) {
      return null;
    }
  }

  Future<String> updateProductQuantity(int id, int quantity, String operation, String token) async {
    try {
      final response = await _http.post(baseUrl + "/cart/product/update/", headers: {'Authorization': 'Token ' + token}, 
      body: jsonEncode(
        {
          'id': id, 
          'quantity': quantity, 
          'operation': operation
        }
      ));
     return _extractData(response)['error'];
    } catch(e) {
      print(e.toString());
      return "ERROR";
    }
  }
  
  dynamic _extractData(Response resp) => json.decode(resp.body);
}