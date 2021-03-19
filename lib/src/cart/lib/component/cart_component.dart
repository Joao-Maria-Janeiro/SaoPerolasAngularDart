import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:saoperolas/src/route_paths.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/cart/lib/model/cart.dart';
import 'package:saoperolas/src/cart/lib/service/cart_service.dart';

@Component(
  selector: 'cart',
  directives: [coreDirectives, formDirectives, routerDirectives],
  templateUrl: 'cart_component.html',
  styleUrls: ['cart_component.css'],
)
class CartComponent implements OnActivate {
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  Cart cart;
  dynamic cart_window = window.localStorage.containsKey('sao_perolas_info')
      ? jsonDecode(window.localStorage['sao_perolas_info'])
      : {};
  CartService _cartService;
  Router router;
  CartComponent(this._cartService, this.router);
  String error;
  String shippingUrl = RoutePaths.shipping.toUrl();
  RouterState _previous;
  int shipping_cost;
  dynamic coupon;
  String coupon_code, error_coupon, success_coupon;
  double coupon_percentage, coupon_discount = 0;

  void changeProductQuantity(int id, String operation) async {
    if (!loggedIn) {
      dynamic cartz = jsonDecode(window.localStorage['sao_perolas_info']);
      dynamic productToDelete = null;
      for (dynamic productz in cartz['products']) {
        if (productz['id'] == id) {
          if (operation == "remove") {
            productToDelete = productz;
          }
          if (operation == "increase") {
            if (productz['quantity'] + 1 <= productz['available_quantity']) {
              productz['quantity'] += 1;
            } else {
              error = "A quantidade pretendida não está disponível";
              Future.delayed(Duration(milliseconds: 2000))
                  .then((onValue) => error = "");
            }
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
      cart = await getCartFromInputJson(cartz);
    } else {
      error = await _cartService.updateProductQuantity(
          id, 1, operation, window.localStorage['sao_perolas_key']);
      if (error.isEmpty) {
        cart.products.forEach((product) {
          if (product.id == id) {
            if (operation == 'increase') {
              product.quantity++;
              cart.total_price += product.unit_price;
            } else if (operation == 'subtract') {
              product.quantity--;
              cart.total_price -= product.unit_price;
            } else {
              cart.products.remove(product);
              cart.total_price -= product.unit_price * product.quantity;
              if (cart.total_price == shipping_cost) {
                cart.total_price = 0;
              }
            }
          }
        });
      } else {
        if (error == 'A quantidade tem de ser maior que 0') {
          cart.products.forEach((product) {
            if (product.id == id) {
              cart.products.remove(product);
              cart.total_price -= product.unit_price;
              if (cart.total_price == shipping_cost) {
                cart.total_price = 0;
              }
            }
          });
        }
      }
      window.localStorage['sao_perolas_info'] = cartToJson(cart);
    }
  }

  void goBack() async {
    await router.navigate(_previous.path);
  }

  double roundDoubleTo2DecimalPlaces(double value) {
    double mod = pow(10.0, 2);
    return ((value * mod).round().toDouble() / mod);
  }

  Future<double> validateCupon(String coupon_code, double total_price,
      bool displayAndStoreCoupon) async {
    coupon = await _cartService.checkCoupon(coupon_code);
    error_coupon = coupon['error'];
    if (error_coupon.isEmpty) {
      double minimum_value = double.parse(coupon['minimum_value']);
      if (total_price > minimum_value) {
        coupon_percentage = double.parse(coupon['percentage']);
        coupon_discount =
            roundDoubleTo2DecimalPlaces(coupon_percentage * total_price);
        total_price -= coupon_discount;
        if (displayAndStoreCoupon) {
          success_coupon = 'Cupão aplicado com sucesso';
          Future.delayed(Duration(milliseconds: 2000))
              .then((onValue) => success_coupon = '');
          window.localStorage['coupon'] = coupon_code;
        }
      } else {
        error_coupon = 'O valor do carrinho tem de ser superior a ' +
            minimum_value.toString() +
            "€";
        // Reset coupon and remove discount message from html page
        coupon_discount = 0;
        window.localStorage.remove("coupon");
      }
    } else {
      // Reset coupon and remove discount message from html page
      coupon_discount = 0;
      window.localStorage.remove("coupon");
    }
    return total_price;
  }

  void checkCoupon() async {
    if (window.localStorage.containsKey("coupon")) {
      if (window.localStorage['coupon'] == coupon_code) {
        // Can't use the same coupon twice in the same purchase
        return;
      } else {
        // Remove discount from current coupon to apply the new one
        cart.total_price += coupon_discount;
      }
    }
    cart.total_price = await validateCupon(
        coupon_code, cart.total_price, /*displayAndStoreCoupon=*/ true);
  }

  @override
  void onActivate(RouterState previous, RouterState current) async {
    shipping_cost = await _cartService.getShippingPrice();
    _previous = previous;
    if (!loggedIn) {
      cart = await getCartFromInputJson(cart_window);
    } else {
      cart = await _cartService
          .getCartForUser(window.localStorage['sao_perolas_key']);
      window.localStorage['sao_perolas_info'] = cartToJson(cart);
      coupon_discount = 0;
      if (window.localStorage.containsKey('coupon')) {
        coupon_code = window.localStorage['coupon'];
        cart.total_price = await validateCupon(
            coupon_code, cart.total_price, /*displayAndStoreCoupon=*/ false);
      }
    }
  }

  Future<Cart> getCartFromInputJson(dynamic in_cart) async {
    List<CartProduct> products = [];
    double total_price = 0;
    if (in_cart.containsKey('products')) {
      (in_cart['products'] as List).forEach((product) {
        products.add(CartProduct(product['id'], product['name'],
            product['image'], product['unit_price'], product['quantity']));
        total_price += (product['unit_price'] * product['quantity']);
      });
    }
    coupon_discount = 0;
    if (window.localStorage.containsKey('coupon')) {
      coupon_code = window.localStorage['coupon'];
      total_price = await validateCupon(
          coupon_code, total_price, /*displayAndStoreCoupon=*/ false);
    }
    return Cart(-1, products, shipping_cost,
        total_price <= 0 ? 0 : total_price + shipping_cost);
  }

  dynamic cartToJson(Cart cart) {
    List products = cart.products
        .map((product) => {
              'id': product.id,
              'name': product.name,
              'quantity': product.quantity,
              'unit_price': product.unit_price,
              'image': product.imageUrl
            })
        .toList();
    return jsonEncode({'products': products});
  }
}
