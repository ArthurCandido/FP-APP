import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening the download link
import '../../querys/nfe.dart'; // Ensure this fetches the correct data
import 'package:http/http.dart' as http;
import '../jwt_token.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'nfs_add_admin_page.dart'; // Import your AddNotaFiscalScreen

class NfeListAdmPage extends StatefulWidget {
  const NfeListAdmPage({super.key});

  @override
  _NfeListAdmPageState createState() => _NfeListAdmPageState();
}

class _NfeListAdmPageState extends State<NfeListAdmPage> {
  List<Map<String, dynamic>> notasFiscais = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotasFiscais();
  }

  Future<void> fetchNotasFiscais() async {
    try {
      final data = await listarNotaFiscalAdm(); // Fetch NF-e list
      setState(() {
        notasFiscais = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Optionally show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar notas fiscais: $e")),
      );
    }
  }

  void navigateToAddNotaFiscal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotaFiscalScreen()),
    );

    if (result == true) {
      fetchNotasFiscais(); // Refresh the list if nota fiscal was added
    }
  }

void openNotaFiscalDialog(BuildContext context, Map<String, dynamic> nota) {
  bool status = nota['preenchida'];
  String value = status ? "Preenchido" : "Pendente";
  String cpfUsuario = nota['cpf_usuario'];
  String mes = nota['mes'].toString();
  String ano = nota['ano'].toString();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Detalhes da Nota Fiscal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Mês: ${nota['mes'] ?? 'N/A'}"),
            Text("Ano: ${nota['ano'] ?? 'N/A'}"),
            Text("CPF: ${nota['cpf_usuario'] ?? 'N/A'}"),
            Text("Status: $value"),
          ],
        ),
        actions: [
          // Use a Row to align buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fechar"),
              ),
              if (value != "Pendente") // Only show if status is NOT "Pendente"
                TextButton(
                  onPressed: () async {
                    String downloadUrl =
                        "http://localhost:3000/api/admin/notafiscal/download/$cpfUsuario/$mes/$ano"; // Your API URL

                    // Use Dio to download the file
                    try {
                      Dio dio = Dio();
                      final response = await dio.get(
                        downloadUrl,
                        options: Options(
                          responseType: ResponseType.bytes,
                          headers: {
                            'authorization': token, // Add your token here
                          },
                        ),
                      );

                      // Get the file name from the response or create one
                      String filename =
                          "nota_fiscal_$cpfUsuario$mes$ano.pdf"; // Adjust extension as needed
                      String dir =
                          (await getApplicationDocumentsDirectory()).path;
                      File file = File('$dir/$filename');

                      // Write the file
                      await file.writeAsBytes(response.data);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Arquivo baixado com sucesso: $filename")),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Erro ao tentar baixar o arquivo: $e")),
                      );
                    }
                  },
                  child: const Text("Baixar"),
                ),
            ],
          ),
        ],
      );
    },
  );
}

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NF-e para Análise',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notasFiscais.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma NF-e para análise.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: notasFiscais.length,
                  itemBuilder: (context, index) {
                    final nota = notasFiscais[index];
                    String value =
                        nota['preenchida'] ? "Preenchido" : "Pendente";

                    return ListTile(
                      title: Text(
                          '${nota['mes'] ?? 'No mês'}/${nota['ano'] ?? 'No ano'}'),
                      subtitle: Text("Status: $value"),
                      onTap: () => openNotaFiscalDialog(context, nota),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddNotaFiscal,
        child: const Icon(Icons.add, color: Colors.white,),
        backgroundColor: const Color(0xFF832f30),
      ),
    );
  }
}
