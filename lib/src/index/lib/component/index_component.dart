import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:saoperolas/src/index/lib/model/cover.dart';
import 'package:saoperolas/src/index/lib/service/index_service.dart';

import '../../../route_paths.dart';

@Component (
  selector: 'index',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'index_component.html',
  styleUrls: ['index_component.css'],
)
class IndexComponent implements OnInit{
  IndexService _service;
  IndexComponent(this._service);
  List<Cover> covers;

  String getUrl(String type) => RoutePaths.products_by_type.toUrl(parameters: {nameParam: '$type'});

  @override
  Future<void> ngOnInit() async {
    covers = await _service.getCoverPhotos();
  }
}
