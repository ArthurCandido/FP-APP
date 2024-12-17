import 'package:flutter/material.dart';
import 'add_holerite_form_page.dart';
import 'edit_holerite_form_page.dart';

class AddHoleritePage extends StatelessWidget {
  const AddHoleritePage({super.key});

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
              title: Text(holerite['nome']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data: ${holerite['data']}'),
                  Text('Funcionário: ${holerite['funcionario']}'),
                ],
              ),
              trailing: Text('ID: ${holerite['id']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditHoleriteFormPage(holerite: holerite),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addHolerite',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHoleriteFormPage(),
            ),
          );
        },
        backgroundColor: const Color(0xFF832f30),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
