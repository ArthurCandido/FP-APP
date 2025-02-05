import 'package:flutter/material.dart';

class NfeListAdmPage extends StatelessWidget {
  const NfeListAdmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NF-e para Análise',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          'Nenhuma NF-e para análise.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
