import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart'; // For masking the CPF
import 'package:http/http.dart' as http;
import '../jwt_token.dart'; // Make sure to import your JWT token management
import 'package:flutter/services.dart';
import 'dart:convert';

class AddNotaFiscalScreen extends StatefulWidget {
  const AddNotaFiscalScreen({Key? key}) : super(key: key);

  @override
  _AddNotaFiscalScreenState createState() => _AddNotaFiscalScreenState();
}

class _AddNotaFiscalScreenState extends State<AddNotaFiscalScreen> {
  DateTime? selectedDate;
  final MaskedTextController cpfController = MaskedTextController(mask: '000.000.000-00');

  Future<void> criarNotaFiscal() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecione uma data.")),
      );
      return;
    }

    final String mes = selectedDate!.month.toString();
    final String ano = selectedDate!.year.toString();
    final String cpfUsuario = cpfController.text;

    if (int.parse(mes) < 1 || int.parse(mes) > 12 || 
        int.parse(ano) < 1960 || int.parse(ano) > 2100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mês deve ser entre 1 e 12, e Ano deve ser entre 1960 e 2100.")),
      );
      return; 
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/admin/notafiscal'), 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,   
        },
        body: jsonEncode({ 
          'mes': mes,
          'ano': ano,
          'cpf_usuario': cpfUsuario,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Nota fiscal criada com sucesso!")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao criar nota fiscal, possivelmente há nota fiscal conflitante")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao enviar a solicitação: $e")),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1961),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Nota Fiscal', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF832f30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: selectedDate == null
                        ? "Data (Clique para selecionar)"
                        : "Data: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: cpfController,
              decoration: const InputDecoration(labelText: "CPF do Usuário"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: criarNotaFiscal,
              child: const Text("Criar Nota Fiscal", style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF832f30), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  