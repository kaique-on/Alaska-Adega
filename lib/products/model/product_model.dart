class Product {
  String name;
  double price;
  int quantity;
  String category;
  String image;
  String description = "";

  Product({ required this.name, required this.price, required this.quantity, required this.category, required this.image});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "quantity": quantity,
      "category": category,
      "image": image,
      "description": description
    };
  }
  static Product fromMap(Map<String, dynamic> json){
    var product = Product( name: json["name"], price: json["price"], quantity: json["quantity"], category: json["category"], image: json["image"]);
    return product;
  }


}