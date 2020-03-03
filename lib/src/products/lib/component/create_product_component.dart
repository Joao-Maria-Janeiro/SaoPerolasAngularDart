@JS()
library k;

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/products/lib/service/product_service.dart';
import 'package:js/js.dart';

@JS()
external void letsCrop();

class LetsCrop {
  LetsCrop();
  void get cropperWrapper => letsCrop();
}

@Component (
  selector: 'create-products',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'create_product_component.html',
  styleUrls: ['create_product_component.css'],
)
class CreateProductComponent implements OnInit, AfterViewChecked {
  ProductService _service;
  CreateProductComponent(this._service);
  File file = null;
  var trimmed = null;
  List<dynamic> types;
  String name, description, prodType;
  double price, quantity;
  String error = '';
  bool success = false;

  @override
  void ngAfterViewChecked() {
    Timer(Duration(seconds: 2), () {
      LetsCrop().cropperWrapper;
    });
  }

  @override
  void ngOnInit() async {
    types = await _service.getProductTypes();
  }

  void submitDetails() async {
    if(window.localStorage.containsKey('sao_perolas_key')) {
      error = await _service.createProduct(name, description, prodType, price, quantity, window.localStorage['upload_image_blob'], window.localStorage['sao_perolas_key']);
      if (error == "") {
        success = true;
      }
    }
  }

}
