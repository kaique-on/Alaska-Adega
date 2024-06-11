class User {

  String nome;
  String email;
  String senha;
  String code = "4l4sk4adm";

  User({ required this.email, required this.senha, required this.nome});

  @override
  String toString(){
    return "nome: $nome, email: $email, senha: $senha";
  }
  

}