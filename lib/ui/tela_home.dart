import 'package:alaska_estoque/user/controller/user_controller.dart';
import 'package:alaska_estoque/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final user;
  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final textoItem = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(            
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(25)),
              
              child: Padding(
                padding: EdgeInsets.only(left: 8, right: 24, top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 264,
                      height: 36,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Pesquise aqui", style: TextStyle(color: Colors.grey),),
                            Icon(Icons.search),
                          ],
                        ),
                    ),
                    
                  ],
                ),
              ),
            ),Icon(Icons.tune),
          ],
                    ),
        ),
      ),
    );
  }
}