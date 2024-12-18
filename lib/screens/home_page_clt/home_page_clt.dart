import 'package:flutter/material.dart';
import 'package:fp_app/screens/holerite_page/holerite_list_page.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';

class HomePageCLT extends StatelessWidget {
  final Map<String, dynamic> user;

  const HomePageCLT({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> user = {
      'nome': 'João Silva',
      'email': 'joao.silva@example.com',
      'cpf': '123.456.789-00',
      'tipo': 'CLT',
    };

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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Nome: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user['nome']!,
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Email: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user['email']!,
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('CPF: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user['cpf']!,
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Tipo de Contrato: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user['tipo']!,
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 70),
              child: Align(
                alignment: Alignment.center,
                child: FloatingActionButton(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
