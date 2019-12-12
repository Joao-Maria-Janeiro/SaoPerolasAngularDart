import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';
import 'package:saoperolas/src/products/lib/service/product_service.dart';
import 'package:image/image.dart';

import '../../../route_paths.dart';



@Component (
  selector: 'product-details',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'product_details_component.html',
)
class ProductDetailsComponent implements OnActivate {
  ProductService _service;
  ProductDetailsComponent(this._service);
  Product product;

  void addToCart(int id) {

  }

  @override
  void onActivate(_, RouterState current) async {
    final productId = getId(current.parameters);
    if (productId != null) product = await _service.getProductFromId(productId);
  }

}
