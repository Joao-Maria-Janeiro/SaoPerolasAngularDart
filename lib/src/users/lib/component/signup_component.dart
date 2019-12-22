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
  Router router;
  SignupComponent(this._service, this.router);
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  String email, password1, password2, firstName, lastName, country, address, zip, city, localidade, error;
  int cell;
  bool submitted = false;
  dynamic response;

  void onSubmit() async {
    submitted = true;
    if(password1 != password2) {
      error = 'As passwords não são iguais';
      return;
    }
    response = await _service.signup(email, password1, password2, firstName, lastName, country, address, zip, city, localidade, error, cell);
    if (response.containsKey('error')) {
      error = response['error'];
    } else {
      dynamic out = await _service.login(email, password1);
      window.localStorage['sao_perolas_key'] = out['token'];
      window.localStorage['sao_perolas_email'] = email;
      window.localStorage['sao_perolas_username'] = out['username'];
      await router.navigate('/');
      window.location.reload();
    }
  }

}
