import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/products/lib/model/product.dart';
import 'package:saoperolas/src/route_paths.dart';
import 'package:saoperolas/src/users/lib/service/login_service.dart';

@Component (
  selector: 'favourites',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'favourites_component.html',
  styleUrls: ['favourites_component.css'],
)
class FavouritesComponent implements OnActivate{
  LoginService _service;
  List<Product> products;
  Router router;
  FavouritesComponent(this._service, this.router);
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key'), editing = false;
  String error;
  int size = 0;
  List<Product> favourites = [];
  List<bool> saveProduct;

  void getAndUpdateProductsAndInfo() async {
    products = await _service.getFavourites(window.localStorage['sao_perolas_key']);
    size = products.length;
    saveProduct = List(size);
    for(int i = 0; i < size; i++) {
      saveProduct[i] = false;
    }
  }
  @override
  void onActivate(RouterState previous, RouterState current) async {
    if (!loggedIn) {
      error = "Precisa de ter sessão iniciada para aceder a esta página";
    } else {
      getAndUpdateProductsAndInfo();
    }
  }

  void cleanUpAndReset() {
    editing = false;
    favourites = [];
  }

  void removeFromFavourites() async {
    for(int i = 0; i < size; i++) {
      if(saveProduct[i] == true) {
        favourites.add(products[i]);
      }
    }
    error = await _service.removeMultipleToFavourites(favourites, window.localStorage['sao_perolas_key']);
    editing = false;
    getAndUpdateProductsAndInfo();
  }

  String getUrl(int id) =>
      RoutePaths.product_details.toUrl(parameters: {idParam: '$id'});

}
