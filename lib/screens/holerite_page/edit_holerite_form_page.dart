import 'package:flutter/material.dart';

class EditHoleriteFormPage extends StatefulWidget {
  final Map<String, String> holerite;

  const EditHoleriteFormPage({super.key, required this.holerite});

  @override
  _EditHoleriteFormPageState createState() => _EditHoleriteFormPageState();
}

class _EditHoleriteFormPageState extends State<EditHoleriteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dataController;
  late TextEditingController _idController;
  late TextEditingController _fileNameController;
  late TextEditingController _funcionarioController;

  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController(text: widget.holerite['data']);
    _idController = TextEditingController(text: widget.holerite['id']);
    _fileNameController = TextEditingController(text: widget.holerite['nome']);
    _funcionarioController =
        TextEditingController(text: widget.holerite['funcionario']);
  }

  @override
  void dispose() {
    _dataController.dispose();
    _idController.dispose();
    _fileNameController.dispose();
    _funcionarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Holerite'),
        backgroundColor: const Color(0xFF832f30),
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
                  TextFormField(
                    controller: _fileNameController,
                    decoration:
                        const InputDecoration(labelText: 'Nome do Arquivo'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do arquivo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _funcionarioController,
                    decoration: const InputDecoration(labelText: 'Funcionário'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do funcionário';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Holerite atualizado com sucesso')),
                        );
                        Navigator.of(context).pop();
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
                      'Salvar',
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
