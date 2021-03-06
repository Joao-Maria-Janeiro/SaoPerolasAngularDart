import 'dart:html';
import 'package:angular_forms/angular_forms.dart';

import 'package:angular/angular.dart';
import 'package:saoperolas/src/cart/lib/component/cart_component.dart';
import 'package:saoperolas/src/cart/lib/component/shipping_component.dart';
import 'package:saoperolas/src/cart/lib/service/cart_service.dart';
import 'package:saoperolas/src/index/lib/component/index_component.dart';
import 'package:saoperolas/src/index/lib/service/index_service.dart';
import 'package:saoperolas/src/products/lib/component/create_product_component.dart';
import 'package:saoperolas/src/products/lib/component/display_product_component.dart';
import 'package:saoperolas/src/products/lib/component/product_details_component.dart';
import 'package:saoperolas/src/products/lib/service/product_service.dart';
import 'package:saoperolas/src/route_paths.dart';
import 'package:saoperolas/src/routes.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/users/lib/component/login_component.dart';
import 'package:saoperolas/src/users/lib/component/signup_component.dart';
import 'package:saoperolas/src/users/lib/service/login_service.dart';


@Component(
  selector: 'my-app',
  providers: [ClassProvider(ProductService), ClassProvider(IndexService), ClassProvider(LoginService), ClassProvider(CartService)],
  directives: [coreDirectives, routerDirectives, formDirectives, DisplayProductComponent, IndexComponent, CreateProductComponent, ProductDetailsComponent, LoginComponent, SignupComponent, CartComponent, ShippingComponent],
  exports: [RoutePaths, Routes],
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
)
class AppComponent implements OnInit{
  ProductService _service;
  AppComponent(this._service);
  List<dynamic> types;
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  String username;

  String getUrl(String type) => RoutePaths.products_by_type.toUrl(parameters: {nameParam: '$type'});

  void logOut() {
    window.localStorage.clear();
    window.location.reload();
  }

  @override
  Future<void> ngOnInit() async {
    types = await _service.getProductTypes();
    if (loggedIn) {
      username = window.localStorage['sao_perolas_username'];
    }
  }
}