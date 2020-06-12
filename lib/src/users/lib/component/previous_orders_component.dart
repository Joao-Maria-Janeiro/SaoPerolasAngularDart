import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/cart/lib/model/cart.dart';
import 'package:saoperolas/src/cart/lib/service/cart_service.dart';
import 'package:saoperolas/src/route_paths.dart';
import 'package:saoperolas/src/routes.dart';
import 'package:saoperolas/src/users/lib/service/login_service.dart';



@Component (
  selector: 'previous-orders',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'previous_orders_component.html',
  styleUrls: ['previous_orders_component.css'],
)
class PreviousOrdersComponent implements OnActivate {
  LoginService _service;
  CartService _cartService;
  PreviousOrdersComponent(this._service, this._cartService);
  List orders;
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  String error;


  @override
  void onActivate(RouterState previous, RouterState current) async {
    if(loggedIn) {
      orders = await _service.getPreviousOrders(window.localStorage['sao_perolas_key']);
    } else {
      error = 'Precisa de ter sessão iniciada para aceder a esta página';
    }
  }

  void getOrderDetails(Order order) async {
    if (order.products.isEmpty) {
      dynamic order_details = await _cartService.getOrderCartAndShipping(window.localStorage['sao_perolas_key'], order.paymnet_intent_id);
      order_details['products'].forEach((k,v) => order.products.add(OrderProduct(k, v)));
      order.shipping = OrderShipping(order_details['morada_1'], order_details['morada_2'], order_details['nome'], true);
    } else {
      order.shipping.show = !order.shipping.show;
    }
  }
}
