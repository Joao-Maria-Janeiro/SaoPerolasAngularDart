import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/route_paths.dart';

import 'package:saoperolas/src/products/lib/component/display_product_component.template.dart' as display_products;
import 'package:saoperolas/src/index/lib/component/index_component.template.dart' as index_component;
import 'package:saoperolas/src/products/lib/component/create_product_component.template.dart' as create_product_c;
import 'package:saoperolas/src/products/lib/component/product_details_component.template.dart' as product_details;
import 'package:saoperolas/src/users/lib/component/login_component.template.dart' as login_c;
import 'package:saoperolas/src/users/lib/component/signup_component.template.dart' as signup_c;


class Routes {
  static final products = RouteDefinition(
    routePath: RoutePaths.products_by_type,
    component: display_products.DisplayProductComponentNgFactory,
  );
  static final index = RouteDefinition(
    routePath: RoutePaths.index,
    component: index_component.IndexComponentNgFactory,
    useAsDefault: true,
  );
  static final createProduct = RouteDefinition(
    routePath: RoutePaths.create_product,
    component: create_product_c.CreateProductComponentNgFactory,
  );
  static final productDetails = RouteDefinition(
    routePath: RoutePaths.product_details,
    component: product_details.ProductDetailsComponentNgFactory,
  );
  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_c.LoginComponentNgFactory,
  );
  static final signup = RouteDefinition(
    routePath: RoutePaths.signup,
    component: signup_c.SignupComponentNgFactory,
  );
  static final all = <RouteDefinition>[
    index,
    productDetails,
    login,
    signup,
    createProduct,
    products,
  ];
}
