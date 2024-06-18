import 'package:alaska_estoque/products/database/product_db.dart';
import 'package:alaska_estoque/products/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductController with ChangeNotifier {

  void addItem(context, Product product) {
    var result = ListProducts.products.where((item) => item.name == product.name);
    if(result.isNotEmpty){
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('Produto já existente! tente inserir um nome diferente', style: TextStyle(fontSize: 10),),
                        Icon(Icons.error)
                    ],
        )));
    }else{
       FirebaseFirestore.instance.collection('products').add(product.toMap());
       notifyListeners();
       ListProducts.products.add(product);
    }
    
  }
  convertMapToObject(String name) async {
    final db = FirebaseFirestore.instance;
    try {
      final querySnapshot =
          await db.collection("products").where("name", isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        final productData = querySnapshot.docs.first.data();           
        return Product.fromMap(productData);
      } else {
        return null;
      }
    } catch (e) {
      print("Erro ao buscar produto por nome: $e");
      throw e;
    }
  }
  void deleteItem(context, String name)async{
    var product = convertMapToObject(name);
    var listaProdutos = ListProducts.getLista();
    listaProdutos.removeAt(product);
    notifyListeners();
    final db = FirebaseFirestore.instance;
    try {
      final querySnapshot =
          await db.collection("products").where("name", isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((document) async{
          await db.collection("products").doc(document.id).delete();
          notifyListeners();
         });
      } else {
        return print("Nenhum produto encontrado");
      }
    } catch (e) {
      print("Erro ao buscar produto por nome: $e");
      throw e;
    }
  }

}