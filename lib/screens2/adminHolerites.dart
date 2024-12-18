import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fp_app/atualizar.dart';
import 'package:fp_app/components/HoleriteAdminItem.dart';
import 'package:fp_app/querys/listarHoleriteAdmin.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';
import 'package:fp_app/screens2/adminHoleriteNovo.dart';
import 'package:http/http.dart';

class AdminHolerites extends StatefulWidget{
  const AdminHolerites({super.key});

  @override
  State<StatefulWidget> createState() => _AdminHoleritesState();
}

class _AdminHoleritesState extends State<AdminHolerites>{

  _AdminHoleritesState(){
    atualizarAdminHolerites = (){setState(() {});};
  }

  Future<List<Map<String, dynamic>>> listar() async{
    Response resposta = await listarHoleritesAdmin();
    if (resposta.statusCode == 200) {
      List dados = jsonDecode(resposta.body);
      var lista = List<Map<String, dynamic>>.from(dados);
      return lista;
    }else{
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holerites', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: (){
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: listar(),
        builder: (context, dados){
          if(dados.hasData){
            List<Map<String, dynamic>> lista = dados.data!;
            if(lista.isEmpty){
              return const Center(
                child: Text("Não há nenhum holerite.")
              );
            }else{
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final instancia = lista[index];
                    return HoleriteAdminItem(instancia);
                  }
                ),
              );
            }
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "FAB FuncionarioPage",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminHoleriteNovo(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF832f30),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]
      ),
    );
  }
}

