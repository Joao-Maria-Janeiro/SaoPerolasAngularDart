import '../../../constants.dart';

class Product {
  int id, quantity, type;
  String name, description, imageUrl;
  double price;

  Product(this.id, this.name, this.description, this.imageUrl, this.type,
      this.price, this.quantity);

  factory Product.fromJson(Map<String, dynamic> product) =>
      Product(
        product['id'],
        product['name'],
        product['description'],
        product['image'],
        product['product_type'],
        product['price'],
        product['available_quantity']
    );



}