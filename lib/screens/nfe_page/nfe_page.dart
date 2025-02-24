import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fp_app/screens/nfe_form_page/nfe_form_page.dart';
import '../jwt_token.dart'; // Make sure this contains your `token`
import '../../querys/nfe.dart';

class NfePage extends StatefulWidget {
  const NfePage({super.key});

  @override
  _NfePageState createState() => _NfePageState();
}

class _NfePageState extends State<NfePage> {
  List<Map<String, dynamic>> notasFiscais = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotasFiscais();
  }

  Future<void> fetchNotasFiscais() async {
    try {
      final data = await listarNotaFiscal();

      setState(() {
        notasFiscais = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

void openNotaFiscalDialog(BuildContext context, Map<String, dynamic> nota) {
  showDialog(
    context: context,
    builder: (context) {
      PlatformFile? selectedFile; // Holds the selected file

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Detalhes da Nota Fiscal"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Mês: ${nota['mes'] ?? 'N/A'}"),
                Text("Ano: ${nota['ano'] ?? 'N/A'}"),
                const SizedBox(height: 10),

                // Show selected file name
                if (selectedFile != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedFile!.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 10),

                // File Picker Button
                ElevatedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null) {
                      setState(() {
                        selectedFile = result.files.single;
                      });
                    }
                  },
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Selecionar PDF"),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons
                children: [
                  // Fechar button (Left Side)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Fechar"),
                  ),

                  // Enviar button (Right Side)
                  TextButton(
                    onPressed: () async {
                      if (selectedFile != null) {
                        // Call upload function
                        var response = await enviarNotaFiscal(
                          nota['mes'],
                          nota['ano'],
                          selectedFile!.path!, // Pass the file path
                        );

                        // Handle response
                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Upload realizado com sucesso!")),
                          );
                          Navigator.pop(context); // Close dialog

                          // Refresh the notas fiscais list
                          fetchNotasFiscais();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Erro ao enviar: ${response.statusCode}")),
                          );
                        }
                      }
                    },
                    child: const Text("Enviar"),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NF-e', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchNotasFiscais,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notasFiscais.isEmpty
              ? const Center(
                  child: Text('Nenhuma NF-e listada.',
                      style: TextStyle(fontSize: 18)),
                )
              : ListView.builder(
                  itemCount: notasFiscais.length,
                  itemBuilder: (context, index) {
                    final nota = notasFiscais[index];

                    return ListTile(
                      title: Text(
                          '${nota['mes'] ?? 'No mês'}/${nota['ano'] ?? 'No ano'}'),
                      subtitle: Text("Clique para adicionar a nota fiscal"),
                      onTap: () {
                        openNotaFiscalDialog(context, nota);
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NfeFormPage()),
          );
        },
        backgroundColor: const Color(0xFF832f30),
        child: const Icon(Icons.add),
      ),
    );
  }
}
