import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/cart/lib/service/cart_service.dart';
import 'package:saoperolas/src/users/lib/service/login_service.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';
import 'package:saoperolas/src/products/lib/service/product_service.dart';
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
  CartService _cartService;
  LoginService _userService;
  Router router;
  ProductDetailsComponent(this._service, this._cartService, this._userService, this.router);
  Product product;
  bool added = false, fav = false;
  String error;

  Future<void> addToCart(int id, String name, double price, String image, int quantity) async {
    if(!window.localStorage.containsKey('sao_perolas_key')) {
      if(!window.localStorage.containsKey('sao_perolas_info')) {
        if(quantity > 0) {
          window.localStorage['sao_perolas_info'] = jsonEncode(
            {
              'products': [
                {
                  'id': id,
                  'name': name,
                  'quantity': 1,
                  'unit_price': price,
                  'image': image,
                  'available_quantity': quantity
                }
              ]
            } 
          );
        } else {
          error = "Not enough quantity";
          return;
        }
      } else {
        bool found = false;
        dynamic cart = jsonDecode(window.localStorage['sao_perolas_info']);
        for (dynamic productz in cart['products']) {
          if (productz['id'] == id) {
            if(productz['quantity'] + 1 <= quantity) {
              productz['quantity'] += 1;
              found = true;
            } else {
              error = "Not enough quantity";
              return;        
            }
          }
        }
        if (found == false) {
          if(quantity > 0) {
            cart['products'].add(
              {
                  'id': id,
                  'name': name,
                  'quantity': 1,
                  'unit_price': price,
                  'image': image,
                  'available_quantity': quantity
                }
            );
          } else {
            error = "Not enough quantity";
            return;
          }
        }
        window.localStorage['sao_perolas_info'] = jsonEncode(cart);
      }
    } else {
      error = await _cartService.addToCart(id, window.localStorage['sao_perolas_key']);
      if( error != "") {
        return;
      }
    }
    added = true;
    Future.delayed(Duration(milliseconds: 2000))
        .then((onValue) => added = false);
  }

  void addToFavourites(int id) async {
    if (window.localStorage.containsKey('sao_perolas_key')) {
      error = await _userService.addToFavourites(id, window.localStorage['sao_perolas_key']);
      fav = true;
    } else {
      await router.navigate(RoutePaths.login.toUrl());
    }
  }

  void removeFromFavourites(int id) async {
    if (window.localStorage.containsKey('sao_perolas_key')) {
      error = await _userService.removeFromFavourites(id, window.localStorage['sao_perolas_key']);
      fav = false;
    } else {
      await router.navigate(RoutePaths.login.toUrl());
    }
  }

  String getUrl() => RoutePaths.cart.toUrl();

  @override
  void onActivate(_, RouterState current) async {
    final productId = getId(current.parameters);
    if (productId != null) {
      product = await _service.getProductFromId(productId);
      if(window.localStorage.containsKey('sao_perolas_key')) {
        fav = await _service.productIsFavourite(window.localStorage['sao_perolas_key'], productId);
      }
    }
  }

}
