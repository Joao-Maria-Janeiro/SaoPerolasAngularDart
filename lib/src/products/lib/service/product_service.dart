import 'dart:convert';

import 'package:http/http.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';

import '../../../constants.dart';

class ProductService {
  final Client _http;
  ProductService(this._http);

  Future<List<Product>> getProductsForType(String type) async {
    try {
      final response = await _http.get(baseUrl + "/products/get/" + type + "/");
      var clean = _extractData(response);
      return (clean as List)
        .map((product) => Product.fromJson(product))
        .toList();
    } catch(e) {
      return [];
    }
  }

  Future<String> createProduct(dynamic form) async {
      final response = await _http.post(baseUrl + "/products/image-test/", body: form);
      return "Success";

  }
  dynamic _extractData(Response resp) => json.decode(resp.body);
}