import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fp_app/components/HoleriteCltItem.dart';
import 'package:fp_app/global.dart';
import 'package:fp_app/querys/listarHoleriteClt.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CltHolerites extends StatefulWidget {
  const CltHolerites({super.key});

  @override
  State<StatefulWidget> createState() => _CltHoleritesState();
}

class _CltHoleritesState extends State<CltHolerites> {
  Future<List<Map<String, dynamic>>> listar() async {
    http.Response resposta = await listarHoleritesClt();
    if (resposta.statusCode == 200) {
      List dados = jsonDecode(resposta.body);
      var lista = List<Map<String, dynamic>>.from(dados);
      return lista;
    } else {
      return [];
    }
  }

  Future<void> registrarPonto(BuildContext context) async {
    try {
      final response = await http.post(
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
      final response = await http.get(
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
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: listar(),
        builder: (context, dados) {
          if (dados.hasData) {
            List<Map<String, dynamic>> lista = dados.data!;
            if (lista.isEmpty) {
              return const Center(child: Text("Não há nenhum holerite."));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final instancia = lista[index];
                    return HoleriteCltItem(instancia);
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => listarEntradasSaidas(context),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.history, color: Colors.white),
            heroTag: "btn1",
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => registrarPonto(context),
            backgroundColor: const Color(0xFF832f30),
            child: const Icon(Icons.access_time, color: Colors.white),
            heroTag: "btn2",
          ),
        ],
      ),
    );
  }
}
