import 'dart:convert';

import 'package:http/http.dart';
import 'package:saoperolas/src/cart/lib/model/cart.dart';
import 'package:encrypt/encrypt.dart';

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
      return "ERROR";
    }
  }

  Future<String> createPaymentIntentAndOrder(dynamic shipping, bool use_saved_details, String token, double total_price, String email, dynamic iv, dynamic encrypter, dynamic cart) async {
    try {
      var response;
      if (use_saved_details) {
        response = await _http.post(baseUrl + "/cart/create-intent/", body: jsonEncode({"token": token}));
      } else {
        response = await _http.post(baseUrl + "/cart/create-intent/", body: jsonEncode(
          {
            "email": shipping['email'],
            "full_name": encrypter.decrypt(Encrypted.from64(shipping['full_name']), iv: iv),
            "address": encrypter.decrypt(Encrypted.from64(shipping['address']), iv: iv),
            "city": shipping['city'],
            "localidade": shipping['localidade'],
            "zip": shipping['zip'],
            "country": shipping['country'],
            "cell": encrypter.decrypt(Encrypted.from64(shipping['cell']), iv: iv),
            "total_price": total_price,
            "cart": cart['products']
          }
        ));
      }
      print(_extractData(response)['token']);
      return _extractData(response)['token'];
    } catch(e) {
      print(e.toString());
    }
  }
  
  dynamic _extractData(Response resp) => json.decode(resp.body);
}