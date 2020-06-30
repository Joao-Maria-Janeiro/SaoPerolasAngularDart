import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';
import 'package:saoperolas/src/products/lib/service/product_service.dart';

import '../../../route_paths.dart';

@Component(
  selector: 'display-products',
  directives: [coreDirectives, formDirectives, routerDirectives],
  templateUrl: 'display_product_component.html',
  styleUrls: ['display_product_component.css'],
)
class DisplayProductComponent implements OnActivate {
  List<Product> products;
  List<Product> otherProducts = [];
  final ProductService _service;
  DisplayProductComponent(this._service);

  String getUrl(int id) =>
      RoutePaths.product_details.toUrl(parameters: {idParam: '$id'});

  @override
  void onActivate(_, RouterState current) async {
    final productType = getName(current.parameters);
    if (productType != null) {
      products = await _service.getProductsForType(productType);
    }

    if (productType == 'all') {
      otherProducts = await _service.getProductsForType('rest');
    }
  }
}
