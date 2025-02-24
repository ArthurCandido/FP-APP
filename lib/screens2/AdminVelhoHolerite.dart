import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fp_app/components/PopupConfirmacao.dart';
import 'package:fp_app/components/PopupError.dart';
import 'package:fp_app/components/PopupProgress.dart';
import 'package:fp_app/global.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Adminvelhoholerite extends StatefulWidget{

  final int? mes;
  final int? ano;
  final String? cpf;
  final String? nome;
  final String? caminho;

  const Adminvelhoholerite({super.key, this.mes, this.ano, required this.cpf, required this.nome, required this.caminho});

  @override
  State<StatefulWidget> createState() => _AdminvelhoholeriteState(mes, ano, cpf, nome, caminho);
}

class _AdminvelhoholeriteState extends State<Adminvelhoholerite>{

  int? mes;
  int? ano;
  String? cpf;
  String? nome;
  String? caminho;
  String? arquivo;

  _AdminvelhoholeriteState(this.mes,this.ano,this.cpf,this.nome,this.caminho);

  final chave = GlobalKey<FormState>();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        arquivo = result.files.single.path;
      });
    }
  }

  baixar() async {
    try {
      Dio dio = Dio();
      String url = "$Gdominio/admin/holerite/dow"; // Ajuste a URL conforme necessário

      // Obter diretório de Downloads no Windows/Linux/macOS
      Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        print("Erro: Não foi possível encontrar a pasta Downloads.");
        return;
      }

      // Definir o caminho do arquivo
      String filePath = "${downloadsDir.path}/holerite $mes-$ano $cpf.pdf";

      // Fazendo o POST com os dados e especificando JSON no header
      final response = await dio.post(
        url,
        data: {"cpf": cpf, "mes": mes, "ano": ano},
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            "Content-Type": "application/json",
            "Authorization": Gtoken, // Enviando token de autenticação
          },
        ),
      );

      // Criando o arquivo e salvando os bytes
      File file = File(filePath);
      await file.writeAsBytes(response.data);

      print("Download concluído: $filePath");
    } catch (e) {
      print("Erro ao baixar o holerite: $e");
    }
  }

  deletar(){
    showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PopupConfirmacao(
              mensagem: "Tem certeza que deseja deletar este holerite?",
              executar: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const PopupProgress();
                  },
                );

                final response = await http.post(
                  Uri.parse("$Gdominio/admin/holerite/del"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'authorization': Gtoken
                  },
                  body: jsonEncode({
                    "cpf": cpf,
                    "ano": ano,
                    "mes": mes,
                  }),
                );

                Navigator.of(context).pop();

                if(response.statusCode == 200){
          
                  GatualizarHolerites();
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

              },
            );
          },
        );
  }

  salvar() async{
    if (chave.currentState!.validate()) {

      if(arquivo!=null){

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const PopupProgress();
          },
        );

        chave.currentState?.save();

        var request = http.MultipartRequest('POST', Uri.parse("$Gdominio/admin/holerite/set"));
        request.headers['Authorization'] = Gtoken;
        request.files.add(await http.MultipartFile.fromPath('file', arquivo!));
        request.fields['cpf'] = cpf!;
        request.fields['mes'] = mes!.toString();
        request.fields['ano'] = ano!.toString();
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        Navigator.of(context).pop();
        
        if(response.statusCode == 200){
          
          GatualizarHolerites();
          Navigator.of(context).pop();

        }else{

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return PopupError(
                  error: jsonDecode(responseBody)["message"]);
            },
          );

        }


      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const PopupError(
                error: "Selecione um arquivo!");
          },
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holerite',
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
                  SizedBox( height: 16,),
                  Container(
                    alignment: Alignment.centerLeft,
                     child: Text(
                      'Data: $ano/$mes',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
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
                  SizedBox( height: 16,),
                  Container(
                    alignment: Alignment.centerLeft,
                     child: Text(
                      "Nome: $nome",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: baixar,
                        icon: const Icon(Icons.attach_file, color: Colors.white),
                        label:const Text(
                          'Baixar Arquivo',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 53, 106, 15),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      //SizedBox(width: 100,),
                      ElevatedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.attach_file, color: Colors.white),
                        label: Text(
                          arquivo == null
                              ? 'Escolher Arquivo'
                              : 'Arquivo: ${arquivo!.split("\\").last}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      
                    ],
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
                      onPressed: deletar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Deletar',
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