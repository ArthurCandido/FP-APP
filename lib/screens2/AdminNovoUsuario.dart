import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:fp_app/components/PopupError.dart';
import 'package:fp_app/components/PopupProgress.dart';
import 'package:fp_app/global.dart';
import 'package:http/http.dart';

class Adminnovousuario extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AdminnovousuarioState();
}

class _AdminnovousuarioState extends State<Adminnovousuario>{
  final chave = GlobalKey<FormState>();
  String? nome;
  String? email;
  String? cpf;
  String? senha;
  String? tipo;
  final MaskedTextController _cpfController = MaskedTextController(mask: '000.000.000-00');

  final List<String> tipos = ['CLT', 'PJ'];

  String? validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nome';
    }
    // Regex para validar o nome (apenas letras)
    String pattern = r'^[a-zA-Z\s]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Por favor, insira um nome válido (apenas letras)';
    }
    return null;
  }

  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o email';
    }
    // Regex para validar o email
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Por favor, insira um email válido';
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

  String? validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a senha';
    }
    if (value.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres';
    }
    return null;
  }

  criar() async{
    if (chave.currentState!.validate()) {

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const PopupProgress();
        },
      );

      chave.currentState?.save();
      final response = await post(
        Uri.parse("$Gdominio/admin/user"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': Gtoken
        },
        body: jsonEncode({
          "cpf": cpf,
          "email": email,
          "senha": senha,
          "nome": nome,
          "tipo": tipo,
        }),
      );

      Navigator.of(context).pop();
      
      if(response.statusCode == 200){
        
        GatualizarUsuarios();
        Navigator.of(context).pop();

      }else{

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const PopupError(
                error: "Esse CPF já foi cadastrado!");
          },
        );

      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Funcionários',
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
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: validarNome,
                    onSaved: (String? texto){
                      nome = texto;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: validarEmail,
                    onSaved: (String? texto){
                      email = texto;
                    },
                  ),
                  TextFormField(
                    controller: _cpfController,
                    decoration: const InputDecoration(labelText: 'CPF'),
                    validator: validarCPF,
                    onSaved: (String? texto){
                      cpf = texto;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: validarSenha,
                    onSaved: (String? texto){
                      senha = texto;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: tipo,
                    decoration:
                        const InputDecoration(labelText: 'Tipo de Contrato'),
                    items: tipos.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (texto) {
                      setState(() {
                        tipo = texto!;
                      });
                    },
                    validator: (value) {
                      if (value == null || !tipos.contains(value)) {
                        return 'Por favor, selecione um tipo de contrato';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
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
                      'Cadastrar',
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