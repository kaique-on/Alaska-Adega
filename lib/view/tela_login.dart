import 'package:alaska_estoque/view/tela_cadastro.dart';
import 'package:alaska_estoque/user/controller/user_controller.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  
    Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

    UserController userController = UserController();
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
                userController.login(context,emailController.text, senhaController.text);
                },
                child: Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 20)),
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
                  Text('Não tem uma conta?'),
                  TextButton(
                    onPressed: (){ Navigator.push(context,MaterialPageRoute(builder: (context) => Cadastro()),);},
                    child:
                    Text('Cadastre-se',
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