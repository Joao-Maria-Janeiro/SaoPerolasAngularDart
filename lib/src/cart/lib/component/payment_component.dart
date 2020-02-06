@JS()
library t;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:encrypt/encrypt.dart';
import 'package:saoperolas/src/route_paths.dart';
import 'package:js/js.dart';

@JS()
external void mountTheCard();

class CardMount {
  CardMount();
  void get card => mountTheCard();
}

@Component (
  selector: 'payment',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'payment_component.html',
)

class PaymentComponent implements AfterViewChecked {
  @override
  void ngAfterViewChecked() {
    Timer(Duration(seconds: 2), () {
      CardMount().card;
    });
  }  
}

