import 'package:alaska_estoque/products/database/product_db.dart';
import 'package:alaska_estoque/products/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductController {

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
      ListProducts.products.add(product);
    }
    
  }

  void deleteItem(context, index){
    ListProducts.products.removeAt(index);
  }

}