import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../../constants.dart';


@Component (
  selector: 'shipping',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'shipping_component.html',
)
class ShippingComponent {
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  String full_name, address, city, localidade, zip, country, cell, email;

  void submitShippingDetails() {
    
  }
}

