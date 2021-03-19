import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:encrypt/encrypt.dart';
import 'package:saoperolas/src/cart/lib/model/cart.dart';
import 'package:saoperolas/src/cart/lib/service/cart_service.dart';
import 'package:saoperolas/src/route_paths.dart';


@Component (
  selector: 'shipping',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'shipping_component.html',
)
class ShippingComponent implements OnInit {
  Router router;
  CartService _cartService;
  ShippingComponent(this.router, this._cartService);
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  String full_name, address, city, localidade, zip, country, cell, email, errors;
  String loginUrl = RoutePaths.login.toUrl();
  int shipping_cost;


  Future<void> setUserDetails(bool userServerDetails) async {
    if(userServerDetails) {
      window.localStorage['sao_perolas_use_saved_details'] = 'true';
      window.localStorage.remove('sao_perolas_shipping');
    }
    dynamic output = await _cartService.createPaymentIntentAndOrder(null, userServerDetails, window.localStorage['sao_perolas_key'], 0, null, null, null, null, true, coupon: (window.localStorage.containsKey('coupon') ? window.localStorage['coupon'] : ''));
    if(output.containsKey('token')) {
      if (output['token'].startsWith("pi")) {
        window.localStorage['sao_perolas_order_token'] = output['token'];
        window.localStorage['sao_perolas_order_secret'] = output['secret'];
        await router.navigate(RoutePaths.payment.toUrl());
      }
    } else {
      errors = output["error"];
    } 
  }
  
  Future<void> submitShippingDetails() async {
    if(window.localStorage.containsKey('sao_perolas_info') && (window.localStorage['sao_perolas_info'] != {"products":[]})) {
      window.localStorage['sao_perolas_use_saved_details'] = 'false';
      final key = Key.fromUtf8('my 32 length key................');
      final iv = IV.fromSecureRandom(16);
      final encrypter = Encrypter(AES(key));
      dynamic shipping_details = jsonEncode(  
        {
          'full_name': encrypter.encrypt(full_name, iv: iv).base64,
          'address': encrypter.encrypt(address, iv: iv).base64,
          'city': city,
          'localidade': localidade,
          'zip': zip,
          'country': country,
          'cell': encrypter.encrypt(cell, iv: iv).base64,
          'email': email
        }
      ); 
      window.localStorage['sao_perolas_shipping'] = shipping_details;
      dynamic output = await _cartService.createPaymentIntentAndOrder(shipping_details, false, window.localStorage.containsKey('sao_perolas_key') ? window.localStorage['sao_perolas_key'] : '', getCartFromInputJson(jsonDecode(window.localStorage['sao_perolas_info'])).total_price, email, iv, encrypter, window.localStorage['sao_perolas_info'], loggedIn, coupon: (window.localStorage.containsKey('coupon') ? window.localStorage['coupon'] : ''));
      if(output.containsKey('token')) {
        if (output['token'].startsWith("pi")) {
          window.localStorage['sao_perolas_order_token'] = output['token'];
          window.localStorage['sao_perolas_order_secret'] = output['secret'];
          await router.navigate(RoutePaths.payment.toUrl());
        }
      } else {
        errors = output["error"];
      }   
    } else {
      errors = 'O seu carrinho está vazio. Adicione pelo menos um produto antes de prosseguir';
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

  @override
  void ngOnInit() async {
    shipping_cost = await _cartService.getShippingPrice();
  }
}

