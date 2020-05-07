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
    product['productz']['image'],
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

class OrderShipping {
  String address1, address2, name;
  OrderShipping(this.address1, this.address2, this.name);
}

class OrderProduct {
  String name;
  String quantity;
  OrderProduct(this.name, this.quantity);
}

class Order {
  String date, time, paymnet_intent_id;
  double price;
  OrderShipping shipping;
  List<OrderProduct> products = [];


  Order(this.date, this.time, this.price, this.paymnet_intent_id);
  Order.complete(this.date, this.time, this.price, this.products, this.shipping);

  factory Order.fromJson(Map<String, dynamic> order) => Order(order['date_ordered'].split("T")[0], order['date_ordered'].split("T")[1].split(".")[0], order['total_price']/100, order['payment_intent_id']);
}