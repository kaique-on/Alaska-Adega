import 'package:flutter/material.dart';

class Home extends StatefulWidget {

 

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final textoItem = TextEditingController();  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                  
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
            )
          ],
        ),

      ),
    );
  }
}