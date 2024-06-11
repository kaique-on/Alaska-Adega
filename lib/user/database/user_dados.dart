import 'package:alaska_estoque/user/model/user_model.dart';

class ListaDoUsuario {
   static List<User> user = [
    User(email: 'adm@gmail.com', senha: '123', nome: 'adm')
  ];

  static List<User> getterUsuarios() {
    return user;
  }

}