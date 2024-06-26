import 'package:alaska_estoque/products/controller/product_controller.dart';
import 'package:alaska_estoque/products/model/product_model.dart';
import 'package:alaska_estoque/view/widgetsScreens/editar.dart';

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
  List<Product> filteredProducts = [];
  String selectedCategory = 'Geral';
  final TextEditingController searchController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    productController = Provider.of<ProductController>(context, listen: false);
    productsFuture = productController.getProduct();
    searchController.addListener(filterProducts);
  }
  void filterProducts() {
    String searchQuery = searchController.text;
    productController.getProduct(
      categoryFilter: selectedCategory == 'Geral' ? null : selectedCategory,
      nameFilter: searchQuery.isEmpty ? null : searchQuery,
    ).then((filteredProducts) {
      setState(() {
        this.filteredProducts = filteredProducts;
      });
    });
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
 void showEditDialog(BuildContext context, Widget screen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 8.0,
          child: screen, // Aqui você pode colocar o seu widget de edição
        );
      },
    );
  }
  final textoItem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
           Row(
             children: [
               Expanded(
                 child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Pesquisar produtos',
                      border: OutlineInputBorder(),
                    ),
                  ),
                 ),
               ),
               
             ],
           ),
          Expanded(
            child: Consumer<ProductController>(
              builder: (context, productController, _) {
                return FutureBuilder<List<Product>>(
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
                    if (snapshot.hasData) {
                  productController.productsList = snapshot.data!;
                  filterProducts();
                }

                   Set<String> categories = Set.from(['Geral', ...productController.productsList.map((product) => product.category).toSet()]);
                    if (productController.productsList.isEmpty) {
                      return const Center(child: Text("Nenhum item na lista"));
                    }
                    
                    return Column(
                      children: [
                        //categorias
                        SizedBox(
                          width: 400,
                          height: 32,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                Row(
                                  children: categories.map((category) {
                                    return GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          selectedCategory = category;
                                          filterProducts();
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: Container(
                                        decoration: BoxDecoration(border: Border.all(width: 1, color: selectedCategory == category ? Colors.indigo[900]! : Colors.grey,), borderRadius: BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                          child: Text(category, style: TextStyle(color: selectedCategory == category ? Colors.indigo[900]! : Colors.grey, fontWeight: FontWeight.bold),),
                                        ), ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              Product product = filteredProducts[index];
                              return Container(
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(product.image, height: 75, width: 75),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Text(
                                                product.price.toString(),
                                                style: TextStyle(color: Colors.indigo[900], fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () async{
                                                    productController.decreaseItem(context, product.id, product.quantity);
                                                  },
                                                  icon: const Icon(Icons.remove),
                                                ),
                                                Text(
                                                  product.quantity.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                IconButton(
                                                  onPressed: () async{
                                                    productController.addItem(context, product.id, product.quantity);
                                                  },
                                                  icon: const Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                    showEditDialog(context, Editar(index: index, productsList: filteredProducts));
                                                  },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.indigo[900],
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  child: Text(
                                                    "Editar",
                                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                          ]);});
                            },
                          ),
                        ),
                        
                      ],
                    ));
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


          /* ListTile(
                                title: Text(product.name),
                                subtitle: Text('Preco: ${product.price.toStringAsFixed(2)}'),
                                trailing: SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await productController.addItem(context, product.id, product.quantity);
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                      Text(product.quantity.toString()),
                                      IconButton(
                                        onPressed: () async {
                                          await productController.decreaseItem(context, product.id, product.quantity);
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          await productController.deleteItem(context, products[index].id);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ); */