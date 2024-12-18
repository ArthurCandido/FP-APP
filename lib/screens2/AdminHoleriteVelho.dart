import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_app/components/PopupConfirmacao.dart';
import 'package:fp_app/components/PopupError.dart';
import 'package:fp_app/querys/alterarHoleriteAdmin.dart';
import 'package:fp_app/querys/deletarHoleriteAdmin.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';
import 'package:http/http.dart';

class AdminHoleriteVelho extends StatelessWidget{
  final GlobalKey<FormState> chave = GlobalKey();
  late int ano;
  late int mes;
  // ignore: non_constant_identifier_names
  late String cpf_usuario;

  // ignore: non_constant_identifier_names
  AdminHoleriteVelho({required this.ano, required this.mes, required this.cpf_usuario, super.key});

  alterar(context) async {
    if(chave.currentState!.validate()){
      chave.currentState!.save();
      Response resposta = await alterarHoleritesAdmin(mes, ano, cpf_usuario, 1);
      if(resposta.statusCode == 200){
        Navigator.pop(context);
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopupError(
                error: jsonDecode(resposta.body)["message"]);
          },
        );
      }
    }
  }

  deletar(context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupConfirmacao(mensagem: "Deletar este holerite?", executar: (){
          deletarHoleritesAdmin(mes, ano, cpf_usuario);
          Navigator.pop(context);
        },);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holerite', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Form(
              key: chave,
              child: Column(
                children: [
                  TextFormField(
                    enabled: false,
                    initialValue: mes.toString(),
                    decoration: const InputDecoration(labelText: 'Mês'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Permite apenas números
                      LengthLimitingTextInputFormatter(2), // Limita a 2 dígitos (max 12)
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um mês';
                      }
                      final numValue = int.tryParse(value);
                      if (numValue == null || numValue < 1 || numValue > 12) {
                        return 'Por favor, insira um mês válido';
                      }
                      return null;
                    },
                    onSaved: (valor){
                      mes = int.parse(valor!);
                    },
                  ),
                  TextFormField(
                    enabled: false,
                    initialValue: ano.toString(),
                    decoration: const InputDecoration(labelText: 'Ano'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Permite apenas números
                      LengthLimitingTextInputFormatter(4), // Limita a 2 dígitos (max 12)
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um ano';
                      }
                      final numValue = int.tryParse(value);
                      if (numValue == null || numValue < 2000 || numValue > 2100) {
                        return 'Por favor, insira um ano válido';
                      }
                      return null;
                    },
                    onSaved: (valor){
                      ano = int.parse(valor!);
                    },
                  ),
                  TextFormField(
                    enabled: false,
                    initialValue: cpf_usuario.toString(),
                    decoration: const InputDecoration(labelText: 'CPF'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um cpf';
                      }
                      return null;
                    },
                    onSaved: (valor){
                      cpf_usuario = valor!;
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  children: [
                    /*
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF832f30),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          alterar(context);
                        },
                        child: const Text(
                          'Deletar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    */
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          deletar(context);
                        },
                        child: const Text(
                          'Deletar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}