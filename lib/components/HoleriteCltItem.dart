import 'package:flutter/material.dart';
import 'package:fp_app/screens2/AdminHoleriteVelho.dart';
import 'package:fp_app/screens2/adminHoleriteNovo.dart';
import 'package:fp_app/screens2/cltHoleriteVelho.dart';

class HoleriteCltItem extends StatelessWidget{
  int mes = 1;
  int ano = 1;
  String cpf_usuario = "";

  HoleriteCltItem(Map<String,dynamic> holerite, {super.key}){
    mes = holerite["mes"];
    ano = holerite["ano"];
    cpf_usuario = holerite["cpf_usuario"];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
              CltHoleriteVelho(ano: ano, mes: mes, cpf_usuario:cpf_usuario),
          ),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Mês: $mes',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Ano: $ano',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('CPF: $cpf_usuario',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}