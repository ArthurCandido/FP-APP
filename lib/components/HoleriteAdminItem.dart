import 'package:flutter/material.dart';

class HoleriteAdminItem extends StatelessWidget{
  final Map<String,dynamic> holerite;

  const HoleriteAdminItem(this.holerite, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FuncionarioEditingPage(user: user),
          ),
        );
        */
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
                Text('Mês: ${holerite['mes']}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Ano: ${holerite['ano']}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('CPF: ${holerite['cpf_usuario']}',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}