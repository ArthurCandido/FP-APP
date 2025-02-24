import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:fp_app/components/PopupError.dart';
import 'package:fp_app/components/PopupProgress.dart';
import 'package:fp_app/global.dart';
import 'package:fp_app/screens2/AdminNovoHolerite.dart';
import 'package:http/http.dart';

class Adminvelhousuario extends StatefulWidget{

  final String? nome;
  final String? email;
  final String? cpf;
  final String? senha;
  final String? tipo;

  const Adminvelhousuario({super.key, this.nome, this.email, this.cpf, this.senha, this.tipo});

  @override
  State<StatefulWidget> createState() => _AdminvelhousuarioState(cpf,email,nome,senha,tipo);
}

class _AdminvelhousuarioState extends State<Adminvelhousuario>{
  final chave = GlobalKey<FormState>();
  String? nome;
  String? email;
  String? cpf;
  String? senha;
  String? tipo;

  _AdminvelhousuarioState(this.cpf,this.email,this.nome,this.senha, this.tipo);

  final List<(String, String)> tipos = [('Admin','admin'), ('CLT','CLT'), ('PJ','PJ')];

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

  String? validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres';
    }
    return null;
  }

  deletar(){

  }

  salvar() async{
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
        Uri.parse("$Gdominio/admin/user/set"),
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
            return PopupError(
                error: response.body);
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
                    initialValue: nome,
                    validator: validarNome,
                    onSaved: (String? texto){
                      nome = texto;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    initialValue: email,
                    validator: validarEmail,
                    onSaved: (String? texto){
                      email = texto;
                    },
                  ),
                  SizedBox( height: 16,),
                  Container(
                    alignment: Alignment.centerLeft,
                     child: Text(
                      "CPF: $cpf",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                    initialValue: senha,
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
                    items: tipos.map(((String, String) value) {
                      return DropdownMenuItem<String>(
                        value: value.$2,
                        child: Text(value.$1),
                      );
                    }).toList(),
                    onChanged: (texto) {
                      setState(() {
                        tipo = texto!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF832f30),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Adminnovoholerite(cpf: cpf,)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:const Color(0xFF832f30),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Adicionar Holerite',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}