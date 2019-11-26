import 'package:angular_router/angular_router.dart';
const nameParam = 'name';

class RoutePaths {
  static final products_by_type = RoutePath(path: 'products/:$nameParam');
  static final create_product = RoutePath(path: 'products/create');
  static final index = RoutePath(path: '/');
}
String getName(Map<String, String> parameters) {
  String name = parameters[nameParam];
  name = name.replaceAll(' ', '-');
  return name == null ? null : name;
}
