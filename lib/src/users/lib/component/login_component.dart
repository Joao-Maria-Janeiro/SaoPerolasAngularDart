import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/route_paths.dart';
import 'package:saoperolas/src/users/lib/service/login_service.dart';

@Component(
  selector: 'login',
  directives: [coreDirectives, formDirectives, routerDirectives],
  templateUrl: 'login_component.html',
)
class LoginComponent implements OnActivate {
  LoginService _service;
  Router router;
  LoginComponent(this._service, this.router);
  String email, passwordz;
  dynamic out;
  bool submitted, success;
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  String signup = RoutePaths.signup.toUrl();
  RouterState _previous;

  Future<void> onSubmit() async {
    submitted = true;
    success = true;
    out = await _service.login(email, passwordz);
    if (!out.containsKey('error')) {
      success = true;
      window.localStorage['sao_perolas_key'] = out['token'];
      window.localStorage['sao_perolas_email'] = email;
      window.localStorage['sao_perolas_username'] = out['username'];
      await router.navigate(_previous.path);
      window.location.reload();
    } else {
      success = false;
    }
  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    _previous = previous;
  }
}
