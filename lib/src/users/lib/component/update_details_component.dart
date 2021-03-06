import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/route_paths.dart';
import 'package:saoperolas/src/users/lib/model/user.dart';
import 'package:saoperolas/src/users/lib/service/login_service.dart';

@Component (
  selector: 'update-details',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'update_details_component.html',
)
class UpdateDetailsComponent implements OnActivate{
  LoginService _service;
  UpdateDetailsComponent(this._service);
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  String error;
  User user;
  String email, first_name, last_name, country, address, zip, city, localidade, cell;
  bool submitted = false;

  @override
  void onActivate(RouterState previous, RouterState current) async {
    if (!loggedIn) {
      error = "Precisa de ter sessão iniciada para aceder a esta página";
    } else {
      user = await _service.getUserDetails(window.localStorage['sao_perolas_key']);
    }
  }

  void onSubmit() async {
    error = await _service.updateUserDetails(window.localStorage['sao_perolas_key'], email, first_name, last_name, country, address, zip, city, localidade, cell);
    submitted = true;
  }
}
