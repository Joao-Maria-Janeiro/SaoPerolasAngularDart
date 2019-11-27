import 'dart:convert';
import 'package:http/http.dart';

import 'package:angular/angular.dart';
import 'package:saoperolas/src/index/lib/component/index_component.dart';
import 'package:saoperolas/src/index/lib/service/index_service.dart';
import 'package:saoperolas/src/products/lib/component/create_product_component.dart';
import 'package:saoperolas/src/products/lib/component/display_product_component.dart';
import 'package:saoperolas/src/products/lib/service/product_service.dart';
import 'package:saoperolas/src/route_paths.dart';
import 'package:saoperolas/src/routes.dart';
import 'package:angular_router/angular_router.dart';


// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  providers: [ClassProvider(ProductService), ClassProvider(IndexService)],
  directives: [coreDirectives, routerDirectives, DisplayProductComponent, IndexComponent, CreateProductComponent],
  exports: [RoutePaths, Routes],
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
)
class AppComponent implements OnInit{
  // Nothing here yet. All logic is in TodoListComponent.
  final Client _http;
  AppComponent(this._http);
  List<dynamic> types;

  String getUrl(String type) => RoutePaths.products_by_type.toUrl(parameters: {nameParam: '$type'});

  @override
  Future<void> ngOnInit() async {
    final response = await _http.get("http://127.0.0.1:8000" + "/products/types/");
    var clean = json.decode(response.body);
    types = (clean as List).map((type) => type['name']).toList();
  }
}