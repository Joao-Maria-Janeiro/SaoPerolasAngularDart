import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/index/lib/model/cover.dart';
import 'package:saoperolas/src/index/lib/service/index_service.dart';
import 'package:js/js.dart';
import 'package:saoperolas/src/routes.dart';

import '../../../route_paths.dart';

@Component (
  selector: 'terms-conditions',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'terms_and_conditions_component.html',
  exports: [RoutePaths, Routes],
)
class TermsAndConditionsComponent {
  
}
