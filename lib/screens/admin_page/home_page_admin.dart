import 'package:flutter/material.dart';
import 'package:fp_app/screens/funcionario_page/funcionario_page.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';

class HomePageAdmin extends StatelessWidget {
  const HomePageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Admin'),
        backgroundColor: const Color(0xFF832f30),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FuncionarioPage()),
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
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Nome: João Silva',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Email: joao.silva@example.com',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('CPF: 123.456.789-00',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Tipo de Contrato: CLT',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FuncionarioPage()),
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
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Nome: Maria Souza',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Email: maria.souza@example.com',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('CPF: 987.654.321-00',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Tipo de Contrato: PJ',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
