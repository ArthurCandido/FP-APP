import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fp_app/screens/holerite_page/holerite_list_page.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';

class HomePageCLT extends StatelessWidget {
  final Map<String, dynamic> user;

  const HomePageCLT({super.key, required this.user});

  Future<void> registrarPonto(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-api-url.com/clt/ponto'), // Replace with your API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_JWT_TOKEN', // Replace with the actual token
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações do Funcionário',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Nome: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(user['nome'],
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Email: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(user['email'],
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('CPF: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(user['cpf'],
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Tipo de Contrato: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(user['tipo'],
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btnPonto",
            onPressed: () => registrarPonto(context),
            backgroundColor: const Color(0xFF832f30),
            child: const Icon(Icons.access_time, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btnHolerite",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HoleriteListPage(),
                ),
              );
            },
            backgroundColor: const Color(0xFF832f30),
            child: const Icon(Icons.receipt, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
