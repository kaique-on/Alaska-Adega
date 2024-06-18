
class UserModel {
  String nome;
  String email;
  String senha;
  String code = "4l4sk4adm";

  UserModel({ required this.email, required this.senha, required this.nome});

  @override
  String toString(){
    return "nome: $nome, email: $email, senha: $senha";
  }

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "email": email,
      "senha": senha
    };
  }
  static UserModel fromMap(Map<String, dynamic> json){
    return UserModel(email: json["email"], senha: json["senha"], nome: json["nome"],);
  }
  

}