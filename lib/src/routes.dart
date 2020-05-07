import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/route_paths.dart';

import 'package:saoperolas/src/products/lib/component/display_product_component.template.dart' as display_products;
import 'package:saoperolas/src/index/lib/component/index_component.template.dart' as index_component;
import 'package:saoperolas/src/products/lib/component/create_product_component.template.dart' as create_product_c;
import 'package:saoperolas/src/products/lib/component/product_details_component.template.dart' as product_details;
import 'package:saoperolas/src/users/lib/component/login_component.template.dart' as login_c;
import 'package:saoperolas/src/users/lib/component/signup_component.template.dart' as signup_c;
import 'package:saoperolas/src/cart/lib/component/cart_component.template.dart' as cart_c;
import 'package:saoperolas/src/cart/lib/component/shipping_component.template.dart' as shipping_c;
import 'package:saoperolas/src/cart/lib/component/payment_component.template.dart' as payment_c;
import 'package:saoperolas/src/users/lib/component/favourites_component.template.dart' as favourites_c;
import 'package:saoperolas/src/users/lib/component/update_details_component.template.dart' as update_details_c;
import 'package:saoperolas/src/index/lib/component/privacy_policy_component.template.dart' as privacy_plo_c;
import 'package:saoperolas/src/index/lib/component/terms_and_conditions_component.template.dart' as terms_and_cond_c;
import 'package:saoperolas/src/users/lib/component/previous_orders_component.template.dart' as prev_orders_c;

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
  static final cart = RouteDefinition(
    routePath: RoutePaths.cart,
    component: cart_c.CartComponentNgFactory,
  );
  static final shipping = RouteDefinition(
    routePath: RoutePaths.shipping,
    component: shipping_c.ShippingComponentNgFactory,
  );
  static final payment = RouteDefinition(
    routePath: RoutePaths.payment,
    component: payment_c.PaymentComponentNgFactory,
  );
  static final favourites = RouteDefinition(
    routePath: RoutePaths.favourites,
    component: favourites_c.FavouritesComponentNgFactory,
  );
  static final update_details = RouteDefinition(
    routePath: RoutePaths.update_details,
    component: update_details_c.UpdateDetailsComponentNgFactory,
  );
  static final privacy_pol = RouteDefinition(
    routePath: RoutePaths.privacy_policy,
    component: privacy_plo_c.PrivacyPolicyComponentNgFactory,
  );
  static final terms_and_conds = RouteDefinition(
    routePath: RoutePaths.terms_and_conditions,
    component: terms_and_cond_c.TermsAndConditionsComponentNgFactory,
  );
  static final prev_orders = RouteDefinition(
    routePath: RoutePaths.previous_orders,
    component: prev_orders_c.PreviousOrdersComponentNgFactory,
  );
  static final all = <RouteDefinition>[
    index,
    productDetails,
    login,
    signup,
    cart,
    shipping,
    createProduct,
    payment,
    favourites,
    update_details,
    products,
    privacy_pol,
    terms_and_conds,
    prev_orders,
  ];
}
