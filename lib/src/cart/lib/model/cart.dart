import '../../../constants.dart';

class CartProduct {
  int id, quantity;
  String name, imageUrl;
  double unit_price;
  CartProduct(this.id, this.name, this.imageUrl,
    this.unit_price, this.quantity);
  
factory CartProduct.fromJson(Map<String, dynamic> product) =>
  CartProduct(
    product['id'],
    product['productz']['name'],
    baseUrl + product['productz']['image'],
    product['productz']['price'],
    product['quantity']
  );
}

class Cart {
  int id;
  List<CartProduct> products;
  double total_price;
  double shipping_cost;
  Cart(this.id, this.products, this.shipping_cost, this.total_price);
}