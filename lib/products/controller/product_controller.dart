import 'package:alaska_estoque/products/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProductController with ChangeNotifier {
  List<Product> productsList = [];

  Future<List<Product>> getAllProducts({String? categoryFilter}) async {
    final db = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot;

      if (categoryFilter != null && categoryFilter.isNotEmpty) {
        querySnapshot = await db
            .collection('products')
            .where('category', isEqualTo: categoryFilter)
            .get();
      } else {
        querySnapshot = await db.collection('products').get();
      }
      productsList = querySnapshot.docs
          .map((document) => Product.fromSnapshot(document))
          .where((product) => product.id != 'SaAf7kOeu93DulrFYQvv')
          .toList();
      notifyListeners();
      return productsList;
    } catch (e) {
      print("Erro ao buscar produtos: $e");
      throw e;
    }
  }
  Future<List<Product>> getProduct(String id, {String? categoryFilter}) async {
  final db = FirebaseFirestore.instance;

  try {
    DocumentSnapshot documentSnapshot;

    if (id.isNotEmpty) {
      documentSnapshot = await db.collection('products').doc(id).get();
      if (documentSnapshot.exists) {
        Product product = Product.fromSnapshot(documentSnapshot);
        productsList = [product];
      } else {
        productsList = [];
      }
    } else {
      QuerySnapshot querySnapshot;

      if (categoryFilter != null && categoryFilter.isNotEmpty) {
        querySnapshot = await db
            .collection('products')
            .where('category', isEqualTo: categoryFilter)
            .get();
      } else {
        querySnapshot = await db.collection('products').get();
      }
      productsList = querySnapshot.docs
          .map((document) => Product.fromSnapshot(document))
          .where((product) => product.id != 'SaAf7kOeu93DulrFYQvv')
          .toList();
    }

    notifyListeners();
    return productsList;
  } catch (e) {
    print("Erro ao buscar produtos: $e");
    throw e;
  }
}

  Future<void> addProduct(context, Product product) async {
    var result = productsList.where((item) => item.name == product.name);
    print(result);
    if (result.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Produto já existente! tente inserir um nome diferente',
                style: TextStyle(fontSize: 10),
              ),
              Icon(Icons.error)
            ],
          ),
        ),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('products')
          .add(product.toMap());
      productsList.add(product);
      notifyListeners();
    }
  }

  Future<void> addItem(context, String id, int quantity) async {
    Product? product = await convertMapToObject(id);
    if (product != null) {
      final db = FirebaseFirestore.instance;
      try {
        final docSnapshot = await db.collection('products').doc(id).get();
        int indexProduct = productsList.indexWhere((product) => product.id == id);
        if (docSnapshot.exists && productsList[indexProduct].quantity > 0) {
          quantity++;
          await db.collection('products').doc(id).update({'quantity': quantity});
          productsList.forEach(
            (product) {
              if (product.id == id) {
                product.quantity = quantity; // atualiza a quantidade da variavel local
                notifyListeners();
              }
            },
          );
          print("Diminuiu a quantidade em 1");
        } else {
          print("produto $id não encontrado");
        }
      } catch (e) {
        print("Erro ao atualizar produto: $e");
        throw e;
      }
    }
  }

  Future<void> decreaseItem(context, String id, int quantity) async {
    Product? product = await convertMapToObject(id);
    if (product != null) {
      final db = FirebaseFirestore.instance;
      try {
        final docSnapshot = await db.collection('products').doc(id).get();
        int indexProduct = productsList.indexWhere((product) => product.id == id);
        if (docSnapshot.exists && productsList[indexProduct].quantity > 0) {
          quantity--;
          await db.collection('products').doc(id).update({'quantity': quantity});
          productsList.forEach(
            (product) {
              if (product.id == id) {
                product.quantity = quantity; // atualiza a quantidade da variavel local
                notifyListeners();
              }
            },
          );
          print("Diminuiu a quantidade em 1");
        } else {
          print("produto $id não encontrado");
        }
      } catch (e) {
        print("Erro ao atualizar produto: $e");
        throw e;
      }
    }
  }

  //procura se a string id recebida esta no documentos produto e se estiver retorna ele como objeto
  Future<Product?> convertMapToObject(String id) async {
  final db = FirebaseFirestore.instance;
  try {
    // Busca o documento com o ID especificado
    final docSnapshot = await db.collection('products').doc(id).get();

    // Verifica se o documento foi encontrado
    if (docSnapshot.exists) {
      final productData = docSnapshot.data() as Map<String, dynamic>;
      return Product.fromMap(productData, docSnapshot.id);
    } else {
      print("Produto com ID $id não encontrado");
      return null;
    }
  } catch (e) {
    print("Erro ao buscar produto por ID: $e");
    throw e;
  }
}

  Future<void> deleteItem(context, String id) async {
    Product? product = await convertMapToObject(id);
    if (product != null) {
      final db = FirebaseFirestore.instance;
      try {
        final docSnapshot = await db.collection('products').doc(id).get();

        print(docSnapshot.data());

        if (docSnapshot.exists) {
          await db.collection("products").doc(docSnapshot.id).delete();
          // Remover o produto da lista local
          productsList.removeWhere((element) => element.id == id);
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Produto deletado com sucesso!',
                    style: TextStyle(fontSize: 10),
                  ),
                  Icon(Icons.check)
                ],
              ),
            ),
          );
        } else {
          print("Nenhum produto encontrado");
        }
      } catch (e) {
        print("Erro ao deletar produto: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ocorreu um erro ao deletar o produto!',
                  style: TextStyle(fontSize: 10),
                ),
                Icon(Icons.error)
              ],
            ),
          ),
        );
        throw e;
      }
    }
  }
  Future<void> editItem(context, Product product, String id) async {
    final db = FirebaseFirestore.instance;
    try{
      await db.collection('products').doc(id).update(product.toMap());
      var indexProdutoAntigo = productsList.indexWhere((product) => product.id == id);
      if(indexProdutoAntigo != -1){
        productsList[indexProdutoAntigo] = product;
        notifyListeners();
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Produto não existente!',
                  style: TextStyle(fontSize: 10),
                ),
                Icon(Icons.error)
              ],
            ),
          ));
      }
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Produto editado com sucesso!',
                  style: TextStyle(fontSize: 10),
                ),
                Icon(Icons.check)
              ],
            ),
          ));
    } catch(e){
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ocorreu um erro ao editar o produto!',
                  style: TextStyle(fontSize: 10),
                ),
                Icon(Icons.error)
              ],
            ),
          ));
    }

  }

  // Future<void> editItem(context, Product product, String id) async {
  //   final db = FirebaseFirestore.instance;
  //   final querySnapshot = await db
  //       .collection("products")
  //       .where("id", isEqualTo: id)
  //       .get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     String productID = querySnapshot.docs.first.id;
  //     db.collection('products').doc(productID).update(product.toMap()).then(
  //       (_) {
  //         int index = productsList.indexWhere((item) => item.id == product.id);
  //         if (index != -1) {
  //           productsList[index] = product;
  //           notifyListeners();
  //         }
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             backgroundColor: Colors.green,
  //             content: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   'Produto atualizado com sucesso!',
  //                   style: TextStyle(fontSize: 10),
  //                 ),
  //                 Icon(Icons.check)
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ).catchError(
  //       (error) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             backgroundColor: Colors.red,
  //             content: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   'Ocorreu um erro!',
  //                   style: TextStyle(fontSize: 10),
  //                 ),
  //                 Icon(Icons.error)
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }
}
