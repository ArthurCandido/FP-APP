import 'package:flutter/material.dart';

class HoleriteListPage extends StatelessWidget {
  const HoleriteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> holerites = [
      {
        'data': '01/01/2023',
        'nome': 'Holerite_Janeiro.pdf',
        'id': '1',
        'funcionario': 'João Silva'
      },
      {
        'data': '01/02/2023',
        'nome': 'Holerite_Fevereiro.pdf',
        'id': '2',
        'funcionario': 'Maria Souza'
      },
      {
        'data': '01/03/2023',
        'nome': 'Holerite_Marco.pdf',
        'id': '3',
        'funcionario': 'João Silva'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Holerites', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: holerites.length,
        itemBuilder: (context, index) {
          final holerite = holerites[index];
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
    );
  }
}
