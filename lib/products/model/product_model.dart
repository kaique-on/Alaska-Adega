import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  double price;
  int quantity;
  String category;
  String image;
  String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
    required this.image,
    this.description = '', // Valor padrão definido aqui
  });

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

  static Product fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Product(
      id: snapshot.id,
      name: data['name'] ?? '', // Provide default values if null
      price: data['price']?.toDouble() ?? 0.0,
      quantity: data['quantity'] ?? 0,
      category: data['category'] ?? '',
      image: data['image'] ?? '',
      description: data['description'] ?? '',
    );
  }

  static Product fromMap(Map<String, dynamic> map, String id) {
    var product = Product(
      id: id,
      name: map["name"] ?? '',
      price: map["price"]?.toDouble() ?? 0.0,
      quantity: map["quantity"] ?? 0,
      category: map["category"] ?? '',
      image: map["image"] ?? '',
      description: map['description'] ?? '',
    );
    return product;
  }
   @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, category: $category}';
  }
}