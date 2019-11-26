import '../../../constants.dart';

class Cover {
  String image, type;
  Cover(this.image, this.type);
  factory Cover.fromJson(Map<String, dynamic> cover) => Cover(baseUrl + cover['image'], cover['product_type']);

}