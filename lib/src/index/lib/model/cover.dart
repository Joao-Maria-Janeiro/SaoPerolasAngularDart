import '../../../constants.dart';

class Cover {
  String image, type;
  Cover(this.image, this.type);
  factory Cover.fromJson(Map<String, dynamic> cover) => Cover(cover['image'], cover['product_type']);
}

class Background {
  String image;
  Background(this.image);
  factory Background.fromJson(Map<String, dynamic> bg) => Background(bg['image']);
}