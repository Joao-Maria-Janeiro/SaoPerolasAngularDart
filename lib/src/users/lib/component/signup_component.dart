import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/users/lib/service/login_service.dart';



@Component (
  selector: 'signup-component',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'signup_component.html',
)
class SignupComponent {
  LoginService _service;
  SignupComponent(this._service);
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  String email, password1, password2, firstName, lastName, country, address, zip, city, localidade, error;
  int cell;
  bool submitted = false;

  void onSubmit() async {
    submitted = true;
    if(password1 != password2) {
      error = 'As passwords não são iguais';
      return;
    }
    String out = await _service.signup(email, password1, password2, firstName, lastName, country, address, zip, city, localidade, error, cell);
    print(out);
  }

}
