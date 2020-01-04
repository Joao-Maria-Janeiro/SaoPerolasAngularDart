import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';
import 'package:saoperolas/src/products/lib/service/product_service.dart';
import 'package:image/image.dart';
import 'package:saoperolas/src/route_paths.dart';
import 'package:saoperolas/src/routes.dart';
import 'package:angular_router/angular_router.dart';

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
  bool added = false;

  void addToCart(int id, String name, double price, String image) {
    if(!window.localStorage.containsKey('sao_perolas_key')) {
      if(!window.localStorage.containsKey('sao_perolas_info')) {
        window.localStorage['sao_perolas_info'] = jsonEncode(
          {
            'products': [
              {
                'id': id,
                'name': name,
                'quantity': 1,
                'unit_price': price,
                'image': image
              }
            ]
          } 
        );
      } else {
        bool found = false;
        dynamic cart = jsonDecode(window.localStorage['sao_perolas_info']);
        for (dynamic productz in cart['products']) {
          if (productz['id'] == id) {
            productz['quantity'] += 1;
            found = true;
          }
        }
        if (found == false) {
          cart['products'].add(
            {
                'id': id,
                'name': name,
                'quantity': 1,
                'unit_price': price,
                'image': image
              }
          );
        }
        window.localStorage['sao_perolas_info'] = jsonEncode(cart);
      }
    } else {
      // TODO: handle logged in user
    }

    added = true;
    Future.delayed(Duration(milliseconds: 2000))
        .then((onValue) => added = false);
  }

  String getUrl() => RoutePaths.cart.toUrl();

  @override
  void onActivate(_, RouterState current) async {
    final productId = getId(current.parameters);
    if (productId != null) product = await _service.getProductFromId(productId);
  }

}
