import 'package:angular_router/angular_router.dart';
const nameParam = 'name';
const idParam = '0';

class RoutePaths {
  static final products_by_type = RoutePath(path: 'products/:$nameParam');
  static final product_details = RoutePath(path: 'products/details/:$idParam');
  static final create_product = RoutePath(path: 'products/create');
  static final login = RoutePath(path: 'login');
  static final signup = RoutePath(path: 'signup');
  static final cart = RoutePath(path: 'cart');
  static final shipping = RoutePath(path: 'shipping');
  static final payment = RoutePath(path: 'payment');
  static final index = RoutePath(path: '/');
}
String getName(Map<String, String> parameters) {
  String name = parameters[nameParam];
  name = name.replaceAll(' ', '-');
  return name == null ? null : name;
}

int getId(Map<String, dynamic> parameters) {
  String id = parameters[idParam];
  return id == null ? null : int.parse(id);
}