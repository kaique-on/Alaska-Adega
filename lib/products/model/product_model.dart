class Product {
  int id;
  String name;
  double price;
  int quantity;
  String category;
  String image;
  String description = "";

  Product({required this.id, required this.name, required this.price, required this.quantity, required this.category, required this.image});
}