class CartProduct {
  int id, quantity;
  String name, imageUrl;
  double unit_price;
  CartProduct(this.id, this.name, this.imageUrl,
    this.unit_price, this.quantity);
}

class Cart {
  List<CartProduct> products;
  double total_price;
  double shipping_cost;
  Cart(this.products, this.shipping_cost, this.total_price);
}