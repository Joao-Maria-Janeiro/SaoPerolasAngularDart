import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/products/lib/service/product_service.dart';
import 'package:image/image.dart';



@Component (
  selector: 'create-products',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'create_product_component.html',
)
class CreateProductComponent {
  ProductService _service;
  CreateProductComponent(this._service);
  File file = null;
  var trimmed = null;

  Future<void> onFileChanged(event) async {
    file = event.target.files[0];
    var reader = new FileReader()..readAsArrayBuffer(file);
    await reader.onLoadEnd.first;
    List<int> result = reader.result;
    Image image = decodeJpg(result);
//    trimmed = encodePng(copyCrop(image, (image.width - 100)~/2, (image.height - 100)~/2, 100, 100));
//    await _service.createProduct(base64Encode(result));
  }

}
