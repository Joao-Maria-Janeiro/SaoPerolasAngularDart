import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/cart/lib/model/cart.dart';
import 'package:saoperolas/src/cart/lib/service/cart_service.dart';

import '../../../constants.dart';


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
  String error;


  void changeProductQuantity(int id, String operation) async {   
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
      error = await _cartService.updateProductQuantity(id, 1, operation, window.localStorage['sao_perolas_key']);
      if(error.isEmpty) {
        cart.products.forEach(
          (product) {
            if(product.id == id) {
              if (operation == 'increase') {
                product.quantity ++;
                cart.total_price += product.unit_price;
              } else if (operation == 'subtract') {
                product.quantity --;
                cart.total_price -= product.unit_price;
              } else {
                cart.products.remove(product);
                cart.total_price -= product.unit_price * product.quantity;
                if (cart.total_price == shipping_cost) {
                  cart.total_price = 0;
                }
              }
            }
          }
        );
      } else {
        if (error == 'A quantidade tem de ser maior que 0') {
          cart.products.forEach(
            (product) {
              if(product.id == id) {
                cart.products.remove(product);
                cart.total_price -= product.unit_price;
                if (cart.total_price == shipping_cost) {
                  cart.total_price = 0;
                }
              }
            }
          );
        }
      }
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
        products.add(CartProduct(product['id'], product['name'], product['image'], product['unit_price'], product['quantity']));
        total_price += (product['unit_price'] * product['quantity']);
      }
    );
    return Cart(-1, products, shipping_cost, total_price == 0 ? 0 : total_price + shipping_cost);
  }
}
