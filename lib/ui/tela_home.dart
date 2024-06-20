import 'package:alaska_estoque/products/controller/product_controller.dart';
import 'package:alaska_estoque/products/model/product_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  // final user;
  const Home({super.key,/* required this.user*/});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Product>> productsFuture;
  late ProductController productController;

  @override
  void initState() {
    super.initState();
    productController = Provider.of<ProductController>(context, listen: false);
    productsFuture = productController.getProduct();
  }

  final textoItem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () async {
                final productController = Provider.of<ProductController>(context, listen: false);
                await productController.addProduct(
                  context,
                  Product(
                    id: '',
                    name: 'Produto 195',
                    price: 10,
                    quantity: 5,
                    category: 'categoria 15',
                    image: 'url da imagem'
                  )
                );
                setState(() {
                  productsFuture = productController.getProduct(); // Atualiza a lista de produtos após adicionar um novo produto
                });
              },
              child: const Text('Adicionar produto'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar produtos ${snapshot.error}'),
                  );
                }

                List<Product> products = snapshot.data ?? [];
                Set<String> categories = products.map((product) => product.category).toSet();
                categories.add('geral');

                if (products.isEmpty) {
                  return const Center(child: Text("Nenhum item na lista"));
                }

                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Row(
                        children: categories.map((category) {
                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                if (category == "geral") {
                                  productsFuture = productController.getProduct(); // Carrega todos os produtos
                                } else {
                                  productsFuture = productController.getProduct(categoryFilter: category);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          Product product = products[index];
                          return ListTile(
                            title: Text(product.name),
                            subtitle: Text('Preco: ${product.price.toStringAsFixed(2)}'),
                            trailing: SizedBox(
                              width: 150,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await productController.addItem(context, product.name, product.quantity);
                                    setState(() {
                  productsFuture = productController.getProduct(); // Atualiza a lista de produtos após adicionar um novo produto
                });},
                                    icon: const Icon(Icons.add),
                                  ),
                                  Text(product.quantity.toString()),
                                  IconButton(
                                    onPressed: () async {
                                      await productController.decreaseItem(context, product.name, product.quantity);
                                   setState(() {
                  productsFuture = productController.getProduct(); // Atualiza a lista de produtos após adicionar um novo produto
                }); },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      productController.deleteItem(context, products[index].name);
                                     setState(() {
                  productsFuture = productController.getProduct(); // Atualiza a lista de produtos após adicionar um novo produto
                }); } ,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* 
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body: Column( 
          children: [
            // Barra de pesquisa
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Center(
                      child: Row(            
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(25)),
                          
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 264,
                                  height: 36,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 12),
                                          child: Text("Pesquise aqui", style: TextStyle(color: Colors.grey, fontSize: 14),),
                                        ),
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

          // Categorias
          Container(
              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo[900]!), borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                child: Text("Cervejas Lata", style: TextStyle(color: Colors.indigo[900]),),
              ),
            ),

            SizedBox(height: 16,),

          // Lista de produtos
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network("https://www.kokoriko.com.co/wp-content/uploads/2021/05/504924_HeinekenLata330.png", height: 75, width: 75,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Heineken 350ml", style: TextStyle(fontSize: 20),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text("R\$4,69", style: TextStyle(color: Colors.indigo[900]),),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {}, 
                                    icon: Icon(Icons.remove)),
                                  Text("6"),
                                  IconButton(
                                    onPressed: () {}, 
                                    icon: Icon(Icons.add)),
                                ],
                              ),
                              TextButton(
                                onPressed: () {}, 
                                child: Container( decoration: BoxDecoration(color: Colors.indigo[900],borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text("Editar", style: TextStyle(fontSize: 12, color: Colors.white),),
                                                          ),
                                ))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24,),

              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network("https://www.kokoriko.com.co/wp-content/uploads/2021/05/504924_HeinekenLata330.png", height: 75, width: 75,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Heineken 350ml", style: TextStyle(fontSize: 20),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text("R\$4,69", style: TextStyle(color: Colors.indigo[900]),),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {}, 
                                    icon: Icon(Icons.remove)),
                                  Text("6"),
                                  IconButton(
                                    onPressed: () {}, 
                                    icon: Icon(Icons.add)),
                                ],
                              ),
                              TextButton(
                                onPressed: () {}, 
                                child: Container( decoration: BoxDecoration(color: Colors.indigo[900],borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text("Editar", style: TextStyle(fontSize: 12, color: Colors.white),),
                                                          ),
                                ))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24,),

              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network("https://www.kokoriko.com.co/wp-content/uploads/2021/05/504924_HeinekenLata330.png", height: 75, width: 75,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Heineken 350ml", style: TextStyle(fontSize: 20),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text("R\$4,69", style: TextStyle(color: Colors.indigo[900]),),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {}, 
                                    icon: Icon(Icons.remove)),
                                  Text("6"),
                                  IconButton(
                                    onPressed: () {}, 
                                    icon: Icon(Icons.add)),
                                ],
                              ),
                              TextButton(
                                onPressed: () {}, 
                                child: Container( decoration: BoxDecoration(color: Colors.indigo[900],borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text("Editar", style: TextStyle(fontSize: 12, color: Colors.white),),
                                                          ),
                                ))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24,),

              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network("https://www.kokoriko.com.co/wp-content/uploads/2021/05/504924_HeinekenLata330.png", height: 75, width: 75,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Heineken 350ml", style: TextStyle(fontSize: 20),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text("R\$4,69", style: TextStyle(color: Colors.indigo[900]),),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {}, 
                                    icon: Icon(Icons.remove)),
                                  Text("6"),
                                  IconButton(
                                    onPressed: () {}, 
                                    icon: Icon(Icons.add)),
                                ],
                              ),
                              TextButton(
                                onPressed: () {}, 
                                child: Container( decoration: BoxDecoration(color: Colors.indigo[900],borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text("Editar", style: TextStyle(fontSize: 12, color: Colors.white),),
                                                          ),
                                ))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24,),
            ],
          ),
        ),
      ]));
  }
}

        
          */