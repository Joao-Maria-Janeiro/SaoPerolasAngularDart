import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/cart/lib/model/cart.dart';
import 'package:saoperolas/src/cart/lib/service/cart_service.dart';


@Component (
  selector: 'cart',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'cart_component.html',
  styleUrls: ['cart_component.css'],
)
class CartComponent implements OnActivate {
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  Cart cart;
  dynamic cart_window = jsonDecode(window.localStorage['sao_perolas_info']);
  CartService _cartService;
  CartComponent(this._cartService);


  void changeProductQuantity(int id, String operation) {   
    if (!loggedIn) {
      dynamic cartz = jsonDecode(window.localStorage['sao_perolas_info']);
      dynamic productToDelete = null;
      for (dynamic productz in cartz['products']) {
        if (productz['id'] == id) {
          if (operation == "remove") {
            productToDelete = productz;
          }
          if (operation == "increase"){
            productz['quantity'] += 1;
          } else {
            if (productz['quantity'] > 0) {
              productz['quantity'] -= 1;
              if (productz['quantity'] == 0) {
                productToDelete = productz;
              }
            } 
          }
        }
      }
      cartz['products'].remove(productToDelete);
      window.localStorage['sao_perolas_info'] = jsonEncode(cartz);
      cart = getCartFromInputJson(cartz);
    } else {
      // TODO: handle logged in user
    }
  }

  @override
  void onActivate(RouterState previous, RouterState current) async {
    if (!loggedIn) {
      cart = getCartFromInputJson(cart_window);
    } else {
      cart = await _cartService.getCartForUser(window.localStorage['sao_perolas_key']);
    }
  }

  Cart getCartFromInputJson(dynamic in_cart) {
    List<CartProduct> products = [];
    double total_price = 0;
    (in_cart['products'] as List).forEach(
      (product) {
        products.add(CartProduct(product['id'], product['name'], product['image'], product['unit_price'] * product['quantity'], product['quantity']));
        total_price += (product['unit_price'] * product['quantity']);
      }
    );
    return Cart(-1, products, 3, total_price == 0 ? 0 : total_price + 3);
  }
}
