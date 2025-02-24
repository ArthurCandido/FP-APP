import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:fp_app/components/PopupError.dart';
import 'package:fp_app/components/PopupProgress.dart';
import 'package:fp_app/global.dart';
import 'package:http/http.dart';

class Adminnovonf extends StatefulWidget{

  final String? cpf;

  const Adminnovonf({super.key, this.cpf});

  @override
  State<StatefulWidget> createState() => _AdminnovonfState(cpf);
}

class _AdminnovonfState extends State<Adminnovonf>{
  final chave = GlobalKey<FormState>();
  
  String? cpf;
  int? ano;
  int? mes;


  final MaskedTextController _dataController = MaskedTextController(mask: '0000/00', text: "${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}");
  MaskedTextController _cpfController = MaskedTextController(mask: '000.000.000-00');

  @override
  void initState() {
    super.initState();
    _cpfController = MaskedTextController(mask: '000.000.000-00', text: cpf);
  }

  _AdminnovonfState(this.cpf);

  String? validarData(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma data';
    }
    // Regex para validar o CPF (formato básico)
    String pattern = r'^\d{4}\/\d{2}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Por favor, insira uma data válida (formato: 0000/00)';
    }
    int ano = int.parse(value.split("/")[0]);
    int mes = int.parse(value.split("/")[1]);
    if(ano < 1900 || ano > 2100){
      return 'Por favor, insira um ano válido';
    }
    if(mes < 1 || mes > 12){
      return 'Por favor, insira um mês válido';
    }
    return null;
  }

  String? validarCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o CPF';
    }
    // Regex para validar o CPF (formato básico)
    String pattern = r'^\d{3}\.\d{3}\.\d{3}-\d{2}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Por favor, insira um CPF válido (formato: xxx.xxx.xxx-xx)';
    }
    return null;
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  criar() async {
    if (chave.currentState!.validate()) {
      chave.currentState!.save();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const PopupProgress();
          },
        );

        chave.currentState?.save();

        final response = await post(
          Uri.parse("$Gdominio/admin/nf/add"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'authorization': Gtoken
          },
          body: jsonEncode({
            "cpf": cpf,
            "mes": mes,
            "ano": ano,
          }),
        );

        Navigator.of(context).pop();
        
        if(response.statusCode == 200){
          
          GatualizarNFs();
          Navigator.of(context).pop();

        }else{

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return PopupError(
                  error: jsonDecode(response.body)["message"]);
            },
          );

        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requisitar Nota Fiscal',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Form(
              key: chave,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _dataController,
                    decoration: const InputDecoration(labelText: 'Data'),
                    validator: validarData,
                    onSaved: (String? texto){
                      if(texto!=null){
                        ano = int.parse(texto.split("/")[0]);
                        mes = int.parse(texto.split("/")[1]);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _cpfController,
                    decoration:
                        const InputDecoration(labelText: 'CPF'),
                    validator: validarCPF,
                    onSaved: (String? texto){
                      cpf = texto;
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: criar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF832f30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Adicionar',
                      style: TextStyle(color: Colors.white),
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
