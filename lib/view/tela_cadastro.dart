import 'package:alaska_estoque/view/tela_login.dart';
import 'package:alaska_estoque/user/controller/user_controller.dart';
import 'package:alaska_estoque/user/model/user_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Cadastro());
}

class Cadastro extends StatefulWidget {

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  UserController userController = UserController();
    final nomeController = TextEditingController();
    final codigoController = TextEditingController();
    final emailController = TextEditingController();
    final senhaController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/Alaska Logo.png', height: 160, width: 160,),
              
              SizedBox(height: 32,),

              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 8.0),
              
              TextField(
                controller: codigoController,
                decoration: InputDecoration(
                  labelText: 'Código de validação',
                  prefixIcon: Icon(Icons.verified_user),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                obscureText: true,
              ),
              SizedBox(height: 8.0),
              
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 8.0),
              
              TextField(
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha do usuário',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                obscureText: true,
              ),

              SizedBox(height: 32.0),
              
              ElevatedButton(
                
                onPressed: () {
                  UserModel user = UserModel(
                  email: emailController.text, 
                  senha: senhaController.text,
                  nome: nomeController.text,
                  
                  );
                  userController.cadastrar(context, user, codigoController.text);
                },
                child: Text('Criar conta', style: TextStyle(color: Colors.white, fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 18.0),
                  backgroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Já tem uma conta?'),
                  TextButton(
                    onPressed: (){ Navigator.push(context,MaterialPageRoute(builder: (context) => Login()),);},
                    child:
                    Text('Faça login',
                  style: TextStyle(color: Colors.blue)))
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}
