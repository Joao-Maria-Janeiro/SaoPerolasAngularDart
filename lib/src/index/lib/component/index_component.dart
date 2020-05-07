@JS()
library f;

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/index/lib/model/cover.dart';
import 'package:saoperolas/src/index/lib/service/index_service.dart';
import 'package:js/js.dart';

import '../../../route_paths.dart';
import '../../../routes.dart';

@JS()
external void showCookiePopup();

class ShowCookiePopup {
  ShowCookiePopup();
  void get showCookiePopupWrapper => showCookiePopup();
}

@Component (
  selector: 'index',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'index_component.html',
  styleUrls: ['index_component.css'],
  exports: [RoutePaths, Routes],
)
class IndexComponent implements OnInit{
  IndexService _service;
  IndexComponent(this._service);
  List<Cover> covers;
  Background background;

  String getUrl(String type) => RoutePaths.products_by_type.toUrl(parameters: {nameParam: '$type'});

  @override
  Future<void> ngOnInit() async {
    covers = await _service.getCoverPhotos();
    background = await _service.getBackGroundPhotos();
    Timer(Duration(seconds: 1), () {
      ShowCookiePopup().showCookiePopupWrapper;
    });
  }
}
