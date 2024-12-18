import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fp_app/atualizar.dart';
import 'package:fp_app/components/HoleriteAdminItem.dart';
import 'package:fp_app/components/HoleriteCltItem.dart';
import 'package:fp_app/querys/listarHoleriteClt.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';
import 'package:http/http.dart';

class CltHolerites extends StatefulWidget{
  const CltHolerites({super.key});

  @override
  State<StatefulWidget> createState() => _CltHoleritesState();
}

class _CltHoleritesState extends State<CltHolerites>{

  Future<List<Map<String, dynamic>>> listar() async{
    Response resposta = await listarHoleritesClt();
    if (resposta.statusCode == 200) {
      List dados = jsonDecode(resposta.body);
      var lista = List<Map<String, dynamic>>.from(dados);
      return lista;
    }else{
      return [];
    }
  }

  _CltHoleritesState(){
    atualizarCltHolrites = (){setState(() {});};
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
                    return HoleriteCltItem(instancia);
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
    );
  }
}

