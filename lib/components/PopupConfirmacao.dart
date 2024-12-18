import 'package:flutter/material.dart';

class PopupConfirmacao extends StatelessWidget {
  final String mensagem;
  final Function executar;

  const PopupConfirmacao({super.key, required this.mensagem, required this.executar});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 300,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(mensagem),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      executar();
                      Navigator.pop(context);
                    }, 
                    child: const Text("OK")
                  ),
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}