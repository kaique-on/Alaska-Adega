import 'package:alaska_estoque/products/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductController with ChangeNotifier {
  List<Product> productsList = [];

  Future<List<Product>> getProduct({String? categoryFilter}) async {
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

  Future<void> addItem(context, String name, int quantity) async {
    Product? product = await convertMapToObject(name);
    if (product != null) {
      final db = FirebaseFirestore.instance;
      try {
        QuerySnapshot querySnapshot = await db
            .collection('products')
            .where('name', isEqualTo: name)
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentReference docRef = querySnapshot.docs.first.reference;
          quantity++;
          await docRef.update(
              {'quantity': quantity}); // atualiza a quantidade do firebase
          productsList.forEach((product) {
            if (product.name == name) {
              product.quantity =
                  quantity; // atualiza a quantidade da variavel local
              notifyListeners();
            }
          });
          print("Aumentou a quantidade em 1");
        } else {
          print("produto $name não encontrado");
        }
      } catch (e) {
        print("Erro ao atualizar produto: $e");
        throw e;
      }
    }
  }

  Future<void> decreaseItem(context, String name, int quantity) async {
    Product? product = await convertMapToObject(name);
    if (product != null) {
      final db = FirebaseFirestore.instance;
      try {
        QuerySnapshot querySnapshot = await db
            .collection('products')
            .where('name', isEqualTo: name)
            .limit(1)
            .get();
        int indexProduct =
            productsList.indexWhere((product) => product.name == name);
        if (querySnapshot.docs.isNotEmpty &&
            productsList[indexProduct].quantity > 0) {
          DocumentReference docRef = querySnapshot.docs.first.reference;
          quantity--;
          await docRef.update(
              {'quantity': quantity}); // atualiza a quantidade do firebase
          productsList.forEach(
            (product) {
              if (product.name == name) {
                product.quantity =
                    quantity; // atualiza a quantidade da variavel local
                notifyListeners();
              }
            },
          );
          print("Diminuiu a quantidade em 1");
        } else {
          print("produto $name não encontrado");
        }
      } catch (e) {
        print("Erro ao atualizar produto: $e");
        throw e;
      }
    }
  }

  //procura se a string name recebida esta no documentos produto e se estiver retorna ele como objeto
  convertMapToObject(String name) async {
    final db = FirebaseFirestore.instance;
    try {
      final querySnapshot =
          await db.collection("products").where("name", isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        final productData = querySnapshot.docs.first.data();
        return Product.fromMap(productData, querySnapshot.docs.first.id);
      } else {
        return null;
      }
    } catch (e) {
      print("Erro ao buscar produto por nome: $e");
      throw e;
    }
  }

  void deleteItem(context, String name) async {
    Product? product = await convertMapToObject(name);
    if (product != null) {
      final db = FirebaseFirestore.instance;
      try {
        final querySnapshot = await db
            .collection("products")
            .where("name", isEqualTo: name)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.forEach((document) async {
            await db.collection("products").doc(document.id).delete();
          });
          // Remover o produto da lista local
          productsList.removeWhere((element) => element.name == name);
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
    final querySnapshot = await db
        .collection("products")
        .where("id", isEqualTo: id)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      String productID = querySnapshot.docs.first.id;
      db.collection('products').doc(productID).update(product.toMap()).then(
        (_) {
          int index = productsList.indexWhere((item) => item.id == product.id);
          if (index != -1) {
            productsList[index] = product;
            notifyListeners();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Produto atualizado com sucesso!',
                    style: TextStyle(fontSize: 10),
                  ),
                  Icon(Icons.check)
                ],
              ),
            ),
          );
        },
      ).catchError(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ocorreu um erro!',
                    style: TextStyle(fontSize: 10),
                  ),
                  Icon(Icons.error)
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
