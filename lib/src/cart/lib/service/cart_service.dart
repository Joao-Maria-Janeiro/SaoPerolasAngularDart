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
      final response = await _http.post(baseUrl + "/cart/add/",
          body: jsonEncode({'id': id}),
          headers: {'Authorization': 'Token ' + token});
      return _extractData(response)['error'];
    } catch (e) {
      return "ERROR";
    }
  }

  Future<Cart> getCartForUser(String token) async {
    try {
      final response = await _http.get(baseUrl + "/cart/get/",
          headers: {'Authorization': 'Token ' + token});
      var clean = _extractData(response);
      List products = (clean['products'] as List)
          .map((product) => CartProduct.fromJson(product))
          .toList();
      
      return Cart(
          clean['id'], products, await getShippingPrice(), double.parse(clean['total_price']));
    } catch (e) {
      return null;
    }
  }

  Future<String> updateProductQuantity(
      int id, int quantity, String operation, String token) async {
    try {
      final response = await _http.post(baseUrl + "/cart/product/update/",
          headers: {'Authorization': 'Token ' + token},
          body: jsonEncode(
              {'id': id, 'quantity': quantity, 'operation': operation}));
      return _extractData(response)['error'];
    } catch (e) {
      return "ERROR";
    }
  }

  Future<dynamic> createPaymentIntentAndOrder(
      dynamic shipping,
      bool use_saved_details,
      String token,
      double total_price,
      String email,
      dynamic iv,
      dynamic encrypter,
      dynamic cart,
      bool userSignedIn,
      {String coupon = ''}) async {
    try {
      var response;
      dynamic requestBody;
      if (use_saved_details) {
        requestBody = {"token": token, "use_saved_details": true};
      } else {
        shipping = jsonDecode(shipping);
        if (!userSignedIn) {
          requestBody = {
            "email": shipping['email'],
            "full_name": encrypter
                .decrypt(Encrypted.from64(shipping['full_name']), iv: iv),
            "address": encrypter.decrypt(Encrypted.from64(shipping['address']),
                iv: iv),
            "city": shipping['city'],
            "localidade": shipping['localidade'],
            "zip": shipping['zip'],
            "country": shipping['country'],
            "cell":
                encrypter.decrypt(Encrypted.from64(shipping['cell']), iv: iv),
            "total_price": total_price,
            "products": jsonDecode(cart)['products'],
          };
        } else {
          requestBody = {
            "email": shipping['email'],
            "full_name": encrypter
                .decrypt(Encrypted.from64(shipping['full_name']), iv: iv),
            "address": encrypter.decrypt(Encrypted.from64(shipping['address']),
                iv: iv),
            "city": shipping['city'],
            "localidade": shipping['localidade'],
            "zip": shipping['zip'],
            "country": shipping['country'],
            "cell":
                encrypter.decrypt(Encrypted.from64(shipping['cell']), iv: iv),
            "total_price": total_price,
            "products": jsonDecode(cart)['products'],
            "token": token,
            "use_saved_details": false,
          };
        }
      }
      if (coupon.isNotEmpty) {
        requestBody['coupon'] = coupon;
      }
      response = await _http.post(baseUrl + "/cart/create-intent/",
          body: jsonEncode(requestBody));
      return _extractData(response);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getOrderShipping(String secret, String token) async {
    try {
      final response = await _http.post(baseUrl + "/cart/order-shipping/",
          body: jsonEncode({'token': token, 'secret': secret}));
      return _extractData(response);
    } catch (e) {
      return {};
    }
  }

  Future<dynamic> getOrderCartAndShipping(String user_token, String id) async {
    try {
      final response = await _http.post(
          baseUrl + "/cart/order-shipping-and-cart/",
          headers: {'Authorization': 'Token ' + user_token},
          body: jsonEncode({'id': id}));
      return _extractData(response);
    } catch (e) {
      return {};
    }
  }

  Future<int> getShippingPrice() async {
    try {
      final response = await _http.get(baseUrl + "/cart/shipping-price/");
      return _extractData(response)['price'];
    } catch (e) {
      return 3;
    }
  }

  Future<dynamic> checkCoupon(String coupon_code) async {
    try {
      final response = await _http.post(baseUrl + "/cart/verify-coupon/",
          body: jsonEncode({'coupon': coupon_code}));
      return _extractData(response);
    } catch (e) {
      return "Ocorreu um erro ao contactar o servidor, por favor tente novamente";
    }
  }

  dynamic _extractData(Response resp) => json.decode(resp.body);
}
