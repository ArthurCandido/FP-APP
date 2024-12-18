import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fp_app/components/PopupError.dart';
import 'package:fp_app/querys/listarHoleriteAdmin.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';

class HoleriteListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HoleriteListPageState();
}

class _HoleriteListPageState extends State<HoleriteListPage> {
    List<Map<String, String>> lista = [];
    bool isLoading = true;

    @override
  void initState() {
    super.initState();
    listar();
  }

    Future<void> listar() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await listarHoleritesAdmin();
      if (response.statusCode == 200) {
        setState(() {
          lista = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        showDialog(context: context,builder: (BuildContext context) {return PopupError(
          error: jsonDecode(response.body)["message"]);
        },);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(context: context,builder: (BuildContext context) {return const PopupError(
        error: "Erro ao acessar a API.");
      },);
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
            onPressed: (){listar();},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : lista.isEmpty
          ? const Center(child: Text('No users found'))
          : Padding(
            padding: const EdgeInsets.all(16.0),
            child:ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, index) {
            final holerite = lista[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(holerite['nome'] ?? 'N/A'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Data: ${holerite['data'] ?? 'N/A'}'),
                    Text('Funcionário: ${holerite['funcionario'] ?? 'N/A'}'),
                  ],
                ),
                trailing: Text('ID: ${holerite['id'] ?? 'N/A'}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
