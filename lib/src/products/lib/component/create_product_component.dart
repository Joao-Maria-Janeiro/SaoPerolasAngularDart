import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';
import 'package:saoperolas/src/products/lib/service/product_service.dart';

import '../../../route_paths.dart';

@Component (
  selector: 'create-products',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'create_product_component.html',
//  styleUrls: ['display_product_component.css'],
)
class CreateProductComponent {

}
