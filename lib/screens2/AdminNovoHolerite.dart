import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:fp_app/components/PopupError.dart';
import 'package:fp_app/components/PopupProgress.dart';
import 'package:fp_app/global.dart';
import 'package:http/http.dart';

class Adminnovoholerite extends StatefulWidget {

  final String? cpf;

  const Adminnovoholerite({super.key, this.cpf});

  @override
  State<StatefulWidget> createState() => _AdminnovoholeriteState(cpf);
}

class _AdminnovoholeriteState extends State<Adminnovoholerite>{
  final chave = GlobalKey<FormState>();
  
  String? arquivo;
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

  _AdminnovoholeriteState(this.cpf);

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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        arquivo = result.files.single.path;
      });
    }
  }

  criar() async {
    if (chave.currentState!.validate()) {
      chave.currentState!.save();
      if(arquivo!=null){

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const PopupProgress();
          },
        );

        chave.currentState?.save();

        var request = MultipartRequest('POST', Uri.parse("$Gdominio/admin/holerite/add"));
        request.headers['Authorization'] = Gtoken;
        request.files.add(await MultipartFile.fromPath('file', arquivo!));
        request.fields['cpf'] = cpf!;
        request.fields['mes'] = mes!.toString();
        request.fields['ano'] = ano!.toString();
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        Navigator.of(context).pop();
        
        if(response.statusCode == 200){
          
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
        title: const Text('Adicionar Holerite',
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
                  const SizedBox(height: 20),
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