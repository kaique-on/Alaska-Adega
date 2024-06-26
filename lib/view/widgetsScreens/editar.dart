import 'package:alaska_estoque/products/model/product_model.dart';
import 'package:flutter/material.dart';

class Editar extends StatefulWidget {
  final List<Product> productsList;
  final int index;
  const Editar({super.key, required this.index, required this.productsList});

  @override
  State<Editar> createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  late TextEditingController categoriaCtrl;
  late TextEditingController nomeCtrl;
  late TextEditingController descricaoCtrl;
  late TextEditingController precoCtrl;
@override
  void initState() {
    super.initState();
    Product product = widget.productsList[widget.index];
    categoriaCtrl = TextEditingController(text: product.category);
    nomeCtrl = TextEditingController(text: product.name);
    descricaoCtrl = TextEditingController(text: product.description);
    precoCtrl = TextEditingController(text: product.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 328,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140, height: 12,
                        decoration: BoxDecoration(color: const Color(0xFFe5e5e5), borderRadius: BorderRadius.circular(16)),
                        child:  TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none, // Remover borda
                                  ),
                                  controller: categoriaCtrl, // Inicializar texto
                                 style: TextStyle(fontSize: 12, color: Color(0xFF7f7f7f), fontWeight: FontWeight.bold)),
                      ),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7f7f7f),)),
                    ],
                  ),
                        
                  const SizedBox(height: 16),
              
                  Container(
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black), borderRadius: BorderRadius.circular(16)),
                    height: 160, width: 240,
                    child: const Center(child: Text("Insira sua imagem aqui", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7f7f7f)),)),
                  ),
                        
                  const SizedBox(height: 12),
                        
                  SizedBox(
                    width: 240,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         SizedBox(width: 200, child: Text(widget.productsList[widget.index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.black,))
                      ],),
                  ),
              
                  const SizedBox(height: 8),
                        
                   SizedBox(
                    width: 240,
                    child: Text(widget.productsList[widget.index].description, style: TextStyle(color: Color(0xFF7f7f7f), fontSize: 14),)),
                        
                  const SizedBox(height: 16),
                        
                  Container(
                    decoration: BoxDecoration(color: Colors.indigo[900], borderRadius: BorderRadius.circular(40)),
                    child:  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Text("R\$ ${widget.productsList[widget.index].price}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    )),
                        
                    const SizedBox(height: 16),
                        
                    Column(
                      children: [
                        Container(
                        decoration: BoxDecoration(color: const Color(0xFF0061BB), borderRadius: BorderRadius.circular(40)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text("Atualizar produto", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          
                        )),
                        const SizedBox(height: 16,),
                        const Text("Aperte no campo desejado para editá-lo", style: TextStyle(color: Color(0xFF7f7f7f), fontSize: 12),),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}