import 'package:alaska_estoque/view/tela_home.dart';
import 'package:alaska_estoque/user/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserController with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  void cadastrar(context, UserModel user, String codigo) async {
    if (codigo != user.code) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Código errado, insira o código correto!',
                style: TextStyle(fontSize: 10),
              ),
              Icon(Icons.error)
            ],
          )));
    } else {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email,
          password: user.senha,
        );
        createUser(user);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Text("Cadastro concluido, faça o seu login!"),
              Icon(Icons.check)
            ],
          ),
        ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Senha fraca, tente inserir uma senha mais forte!',
                    style: TextStyle(fontSize: 10),
                  ),
                  Icon(Icons.error)
                ],
              )));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Email já existente, tente inserir outro email ou fazer login',
                    style: TextStyle(fontSize: 10),
                  ),
                  Icon(Icons.error)
                ],
              )));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ocorre um erro durante o cadastro',
                  style: TextStyle(fontSize: 10),
                ),
                Icon(Icons.error)
              ],
            ),
          ),
        );
      }
    }
  }

  void login(context, emailController, senhaController) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController,
        password: senhaController,
      );
      _user = await convertMapToObject(emailController);
      notifyListeners();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (builder) => Home(/*user: user*/)), (route) => false);
      notifyListeners();
      print("teste: $_user");
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Usuário não encontrado, caso não tenha feito a conta clique em cadastro!'),
                Icon(Icons.error)
              ],
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tente inserir credencias válidas'),
                Icon(Icons.error)
              ],
            )));
      }
    }
  }

  createUser(UserModel user) async {
    final db = FirebaseFirestore.instance;

    db.collection("users").add(user.toMap()).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
        notifyListeners();
  }

  convertMapToObject(String email) async {
    final db = FirebaseFirestore.instance;
    try {
      final querySnapshot =
          await db.collection("users").where("email", isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Se houver documentos correspondentes ao email, retornar o primeiro
        final userData = querySnapshot.docs.first.data();
        notifyListeners();
        return UserModel.fromMap(userData);
      } else {
        return null;
      }
    } catch (e) {
      print("Erro ao buscar usuário por email: $e");
      throw e;
    }
  }
}
