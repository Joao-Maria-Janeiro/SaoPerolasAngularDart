@JS()
library t;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:encrypt/encrypt.dart';
import 'package:saoperolas/src/cart/lib/model/cart.dart';
import 'package:saoperolas/src/cart/lib/service/cart_service.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';
import 'package:saoperolas/src/route_paths.dart';
import 'package:js/js.dart';

@JS()
external void mountTheCard();

class CardMount {
  CardMount();
  void get card => mountTheCard();
}

@Component (
  selector: 'payment',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'payment_component.html',
)

class PaymentComponent implements AfterViewChecked, OnActivate {
  CartService _cartService;
  PaymentComponent(this._cartService);
  bool loading = true, submitted = false;
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  Cart cart;
  dynamic shipping;
  String full_name, address1, address2;
  int shipping_cost;

  @override
  void ngAfterViewChecked() {
    Timer(Duration(seconds: 2), () {
      CardMount().card;
      loading = false;
    });
  }

  void setSubmitted() {
    submitted = true;
  }

  @override
  void onActivate(RouterState previous, RouterState current) async {
    shipping_cost = await _cartService.getShippingPrice();
    if(!loggedIn) {
      dynamic cartz = jsonDecode(window.localStorage['sao_perolas_info']);
      cart = getCartFromInputJson(cartz);
    } else {
      cart = await _cartService.getCartForUser(window.localStorage['sao_perolas_key']);
    }
    shipping = await _cartService.getOrderShipping(window.localStorage['sao_perolas_order_secret'], window.localStorage['sao_perolas_order_token']);
    full_name = shipping['nome'];
    address1 = shipping['morada_1'];
    address2 = shipping['morada_2'];
  }  

    Cart getCartFromInputJson(dynamic in_cart) {
    List<CartProduct> products = [];
    double total_price = 0;
    if (in_cart.containsKey('products')) {
      (in_cart['products'] as List).forEach(
        (product) {
          products.add(CartProduct(product['id'], product['name'], product['image'], product['unit_price'], product['quantity']));
          total_price += (product['unit_price'] * product['quantity']);
        }
      );
    }
    return Cart(-1, products, shipping_cost, total_price == 0 ? 0 : total_price + shipping_cost);
  }

}

