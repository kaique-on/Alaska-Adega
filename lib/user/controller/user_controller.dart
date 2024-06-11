import 'package:alaska_estoque/ui/tela_home.dart';
import 'package:alaska_estoque/user/database/user_dados.dart';
import 'package:alaska_estoque/user/model/user_model.dart';
import 'package:flutter/material.dart';

class UserController  {
    
    void cadastrar(context, String codigo, User user){
        
        var result = ListaDoUsuario.user.where((item) => item.email == user.email);
         
        if (user.email.contains('@') && user.email.contains('.com') && codigo == user.code){
            print(ListaDoUsuario.user);
            ListaDoUsuario.user.add(user);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Row(
                    children: [
                        Text('Cadastro concluído, faça o seu login!'),
                        Icon(Icons.check)
                    ],
                )));
        }else if(result.isNotEmpty){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('Email já existente, tente inserir outro email ou fazer login', style: TextStyle(fontSize: 10),),
                        Icon(Icons.error)
                    ],
                )));
        }else {
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

    void login(context, String email, String senha){
        
        print(ListaDoUsuario.user);
        var result = ListaDoUsuario.user.where((item) => item.email == email && item.senha == senha);
        var index = ListaDoUsuario.user.indexWhere((item) => item.email == email);
        if(result.isNotEmpty){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> Home(index: index)), (route) => false, );
        }else{
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