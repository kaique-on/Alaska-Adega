import 'package:alaska_estoque/firebase_options.dart';
import 'package:alaska_estoque/products/controller/product_controller.dart';
import 'package:alaska_estoque/ui/tela_login.dart';
import 'package:alaska_estoque/user/controller/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends MaterialApp {
   MyApp({super.key}) : super(home: Login());
}