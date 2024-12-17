import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddHoleriteFormPage extends StatefulWidget {
  const AddHoleriteFormPage({super.key});

  @override
  _AddHoleriteFormPageState createState() => _AddHoleriteFormPageState();
}

class _AddHoleriteFormPageState extends State<AddHoleriteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String? _fileName;
  String? _selectedFuncionario;

  final List<Map<String, String>> _funcionariosCLT = [
    {'id': '1', 'nome': 'João Silva'},
    {'id': '2', 'nome': 'Maria Souza'},
  ];

  @override
  void dispose() {
    _dataController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
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
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _dataController,
                    decoration: const InputDecoration(labelText: 'Data'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _idController,
                    decoration:
                        const InputDecoration(labelText: 'ID do Holerite'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o ID do holerite';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Selecionar Funcionário CLT'),
                    items: _funcionariosCLT.map((funcionario) {
                      return DropdownMenuItem<String>(
                        value: funcionario['id'],
                        child: Text(funcionario['nome']!),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedFuncionario = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione um funcionário';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file, color: Colors.white),
                    label: Text(
                      _fileName == null
                          ? 'Escolher Arquivo'
                          : 'Arquivo: $_fileName',
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
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _fileName != null) {
                        // adiciona a logica aq dps
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Holerite adicionado com sucesso')),
                        );
                        Navigator.of(context).pop();
                      } else if (_fileName == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Por favor, escolha um arquivo')),
                        );
                      }
                    },
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
