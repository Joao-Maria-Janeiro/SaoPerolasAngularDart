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
  
  Future<Product> getProductFromId(int id) async {
    final response = await _http.get(baseUrl + "/products/details/" + id.toString() + "/");
    var clean = _extractData(response);
    return Product.fromJson(clean);
  }

  Future<String> createProduct(String name, String description, String prodType, double price, double quantity, dynamic image, String token) async {
    try {
      final response = await _http.post(baseUrl + "/products/create/", headers: {'Authorization': 'Token ' + token}, body: jsonEncode({'name': name, 'description': description, 'type': prodType, 'price': price.toString(), 'quantity': quantity.toString(), 'image': image}));
      var clean = _extractData(response);
      return clean['error'];
    } catch(e) {
      return "Erro ao tentar fazer o pedido ao servidor";
    }

  }

  Future<List> getProductTypes() async {
    final response = await _http.get(baseUrl + "/products/types/");
    var clean = json.decode(response.body);
    return (clean as List).map((type) => type['name']).toList();
  }
  dynamic _extractData(Response resp) => json.decode(resp.body);
}