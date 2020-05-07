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
  selector: 'privacy-policy',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'privacy_policy.html',
  exports: [RoutePaths, Routes],
)
class PrivacyPolicyComponent {
  
}
