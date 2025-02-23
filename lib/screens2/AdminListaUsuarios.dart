import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fp_app/global.dart';
import 'package:fp_app/screens/admin_page/user_class.dart';
import 'package:fp_app/screens/funcionario_page/funcionario_editing_page.dart';
import 'package:fp_app/screens/funcionario_page/funcionario_page.dart';
import 'package:fp_app/screens/nfe_list_adm_page/nfe_list_adm_page.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';
import 'package:fp_app/screens2/AdminNovoUsuario.dart';
import 'package:fp_app/screens2/AdminVelhoUsuario.dart';
import 'package:fp_app/screens2/adminHolerites.dart';
import 'package:http/http.dart';

class Adminlistausuarios extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AdminlistausuariosState();
}

class _AdminlistausuariosState extends State<Adminlistausuarios>{
  String? erro;
  bool carregando = true;
  List<Map<String, dynamic>> lista = [];

  int pagina = 0;
  String? cpf_nome;
  ScrollController controelLista = ScrollController();
  double posicaoScroll = 0;
  bool scroll = true;

  GlobalKey<FormState> chave = GlobalKey();

  @override
  void initState() {
    super.initState();
    GatualizarUsuarios = atualizar;
    controelLista.addListener(verificarFimLista);
    listar();
  }

  void verificarFimLista() {
    if (controelLista.position.pixels > controelLista.position.maxScrollExtent - 50 && scroll) {
      posicaoScroll = controelLista.position.pixels;
      listar();
    }
  }

  buscar(){
    chave.currentState?.save();
    pagina = 0;
    lista = [];
    posicaoScroll = 0;
    scroll = true;
    listar();
  }

  atualizar(){
    pagina = 0;
    cpf_nome = "";
    lista = [];
    posicaoScroll = 0;
    scroll = true;
    listar();
  }

  listar() async{
    erro = null;
    carregando = true;
    setState(() {});
    //
    final response = await post(
      Uri.parse("$Gdominio/admin/user/list"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': Gtoken
      },
      body: jsonEncode({
        "pagina": pagina,
        "cpf_nome": cpf_nome,
      }),
    );
    if(response.statusCode == 200){
      int tamanho = lista.length;
      lista += List<Map<String, dynamic>>.from(jsonDecode(response.body));
      if(tamanho == lista.length){
        scroll = false;
      }
    }else{
      erro = response.body;
    }
    //
    pagina ++;
    carregando = false;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
    controelLista.jumpTo(posicaoScroll);
  });
  }

  @override
  Widget build(BuildContext context) {
    Widget conteudo = Container();
    if(erro != null){
      conteudo = Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "ERRO:",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(erro!),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      );
    }else if(carregando){
      conteudo = ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Wrap(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 10),
                      child: Form(
                        key: chave,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'CPF/Nome'),
                                initialValue: cpf_nome,
                                onSaved: (String? texto){
                                  cpf_nome = texto;
                                },
                              )
                            ),
                            IconButton(
                              onPressed: buscar, 
                              icon: const Icon(Icons.search)
                            ),
                          ],
                        ),
                      )
                  ),
                ] + lista.map((Map<String, dynamic> e){
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Adminvelhousuario(cpf: e["cpf"],tipo: e["tipo"],nome: e["nome"],email: e["email"],senha: e["senha"],),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Nome: ${e['nome']}',
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 8),
                                Text('Email: ${e['email']}',
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 8),
                                Text('CPF: ${e['cpf']}',
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 8),
                                Text('Tipo de Contrato: ${e['tipo']}',
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList() + [
                  Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Color(0xFF832f30),
                    ),
                  )
                ]
              )
            ],
          ),
        ]
      );
    }else if(lista != null){
      conteudo = ListView(
        controller: controelLista,
        padding: const EdgeInsets.all(16.0),
        children: [
          Wrap(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 10),
                      child: Form(
                        key: chave,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'CPF/Nome'),
                                initialValue: cpf_nome,
                                onSaved: (String? texto){
                                  cpf_nome = texto;
                                },
                              )
                            ),
                            IconButton(
                              onPressed: buscar, 
                              icon: const Icon(Icons.search)
                            ),
                          ],
                        ),
                      )
                  ),
                ] + lista.map((Map<String, dynamic> e){
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Adminvelhousuario(cpf: e["cpf"],tipo: e["tipo"],nome: e["nome"],email: e["email"],senha: e["senha"],),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Nome: ${e['nome']}',
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 8),
                                Text('Email: ${e['email']}',
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 8),
                                Text('CPF: ${e['cpf']}',
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 8),
                                Text('Tipo de Contrato: ${e['tipo']}',
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList() + [ Container(height: 300,)]
              )
            ],
          ),
        ]
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Admin', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        automaticallyImplyLeading: false,
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
            onPressed: atualizar,
          ),
        ],
      ),
      body: conteudo,
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
                    builder: (context) => Adminnovousuario(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF832f30),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 70),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "FAB AdminHolerites",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHolerites(),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF832f30),
                child: const Icon(Icons.receipt, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                heroTag: "FAB NfeListAdmPage",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NfeListAdmPage(),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF832f30),
                child: const Icon(Icons.list, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ); 
  }
}