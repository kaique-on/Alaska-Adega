import 'package:alaska_estoque/user/model/user_model.dart';

class ListaDoUsuario {
   static List<UserModel> user = [
    UserModel(email: 'adm@gmail.com', senha: '123', nome: 'adm')
  ];

  static List<UserModel> getterUsuarios() {
    return user;
  }

}