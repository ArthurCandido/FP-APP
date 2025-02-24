import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:fp_app/global.dart';
import 'package:fp_app/screens/nfe_list_adm_page/nfe_list_adm_page.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';
import 'package:fp_app/screens2/AdminNovoHolerite.dart';
import 'package:fp_app/screens2/AdminNovoUsuario.dart';
import 'package:fp_app/screens2/AdminVelhoHolerite.dart';
import 'package:fp_app/screens2/AdminVelhoUsuario.dart';
import 'package:fp_app/screens2/CLTVelhoHolerite.dart';
import 'package:fp_app/screens2/adminHolerites.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Cltlistaholerite extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CltlistaholeriteState();
}

class _CltlistaholeriteState extends State<Cltlistaholerite>{
  String? erro;
  bool carregando = true;
  List<Map<String, dynamic>> lista = [];

  int pagina = 0;

  String? cpf_nome;
  int? ano;
  int? mes;

  ScrollController controelLista = ScrollController();
  double posicaoScroll = 0;
  bool scroll = true;

  GlobalKey<FormState> chave = GlobalKey();

  final MaskedTextController _dataController = MaskedTextController(mask: '0000/00');

  @override
  void initState() {
    super.initState();
    GatualizarHolerites = atualizar;
    controelLista.addListener(verificarFimLista);
    listar();
  }

  Future<void> registrarPonto(BuildContext context) async {
    try {
      final response = await post(
        Uri.parse('http://localhost:3000/api/clt/ponto'), // Replace with your API URL
        headers: {
          'Content-Type': 'application/json',
          'authorization': Gtoken, // Replace with actual token
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ponto registrado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${responseData['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar: $error')),
      );
    }
  }

  String formatarData(String data) {
    DateTime dateTime = DateTime.parse(data);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Future<void> listarEntradasSaidas(BuildContext context) async {
    try {
      final response = await get(
        Uri.parse('http://localhost:3000/api/clt/ponto'), // Replace with your API URL
        headers: {
          'Content-Type': 'application/json',
          'authorization': Gtoken, // Replace with actual token
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Histórico de Entradas e Saídas"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return ListTile(
                      title: Text("Data: ${formatarData(item['horario'])}"),
                      subtitle: Text(
                          "Tipo: ${item['entrada_saida'] == true ? 'entrada' : 'saída'}"),
                      leading: Icon(
                        item['entrada_saida'] == true
                            ? Icons.login
                            : Icons.logout,
                        color: item['entrada_saida'] == true
                            ? Colors.green
                            : Colors.red,
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Fechar"),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao buscar histórico de pontos!')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar: $error')),
      );
    }
  }

  String? validarData(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    // Regex para validar o CPF (formato básico)
    String patternano1 = r'^\d{4}$';
    String patternano2 = r'^\d{4}\/$';
    String pattermes = r'^\d{4}\/\d{2}$';
    RegExp regex1 = RegExp(patternano1);
    RegExp regex2 = RegExp(patternano2);
    RegExp regex3 = RegExp(pattermes);
    if (!regex1.hasMatch(value) && !regex2.hasMatch(value) && !regex3.hasMatch(value)) {
      return 'Por favor, insira uma data válida (formato: 0000/00)';
    }
    if(regex3.hasMatch(value)){
      int ano = int.parse(value.split("/")[0]);
      int mes = int.parse(value.split("/")[1]);
      if(ano < 1900 || ano > 2100){
        return 'Por favor, insira um ano válido';
      }
      if(mes < 1 || mes > 12){
        return 'Por favor, insira um mês válido';
      }
    }
    int ano = int.parse(value.split("/")[0]);
    if(ano < 1900 || ano > 2100){
      return 'Por favor, insira um ano válido';
    }
    return null;
  }

  void verificarFimLista() {
    if (controelLista.position.pixels > controelLista.position.maxScrollExtent - 50 && scroll) {
      posicaoScroll = controelLista.position.pixels;
      listar();
    }
  }

  buscar(){
    if(chave.currentState!.validate()){
      chave.currentState?.save();
      pagina = 0;
      lista = [];
      posicaoScroll = 0;
      scroll = true;
      listar();
    }
  }

  atualizar(){
    pagina = 0;
    cpf_nome = null;
    mes = null;
    ano = null;
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
      Uri.parse("$Gdominio/clt/holerite/list"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': Gtoken
      },
      body: jsonEncode({
        "pagina": pagina,
        "ano": ano,
        "mes": mes,
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
                                controller: _dataController,
                                decoration: const InputDecoration(labelText: 'Data'),
                                validator: validarData,
                                onSaved: (String? texto){
                                  if(texto!=null){
                                    try{
                                      ano = int.parse(texto.split("/")[0]);
                                      mes = int.parse(texto.split("/")[1]);
                                    }catch(e){}    
                                  }
                                },
                              ),
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
                                Cltvelhoholerite(cpf: e["cpf_usuario"],mes: e["mes"],ano: e["ano"],nome: e["nome"],caminho: e["caminho"],),
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
                                Text('Data: ${e['ano']}/${e["mes"]}',
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
                                controller: _dataController,
                                decoration: const InputDecoration(labelText: 'Data'),
                                validator: validarData,
                                onSaved: (String? texto){
                                  if(texto!=null){
                                    try{
                                      ano = int.parse(texto.split("/")[0]);
                                    }catch(e){
                                      ano = null;
                                    }    
                                    try{
                                      mes = int.parse(texto.split("/")[1]);
                                    }catch(e){
                                      mes = null;
                                    }  
                                  }
                                },
                              ),
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
                                Cltvelhoholerite(cpf: e["cpf_usuario"],mes: e["mes"],ano: e["ano"],nome: e["nome"],caminho: e["caminho"],),
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
                                Text('Data: ${e['ano']}/${e["mes"]}',
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
        automaticallyImplyLeading: false,
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
              heroTag: "",
              onPressed: () {
                listarEntradasSaidas(context);
              },
              backgroundColor: const Color(0xFF832f30),
              child: const Icon(Icons.history, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 70),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "FAB AdminHolerites",
                onPressed: () {
                  registrarPonto(context);
                },
                backgroundColor: const Color(0xFF832f30),
                child: const Icon(Icons.access_time, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ); 
  }
}