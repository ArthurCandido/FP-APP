import 'package:flutter/material.dart';
import 'package:fp_app/screens/crud_funcionario/user_queries.dart';

class FuncionarioEditingPage extends StatefulWidget {
  final Map<String, dynamic> user; // Accept a user object to populate the form

  const FuncionarioEditingPage({super.key, required this.user});

  @override
  _FuncionarioEditingPageState createState() => _FuncionarioEditingPageState();
}

class _FuncionarioEditingPageState extends State<FuncionarioEditingPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cpfController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordOldController;
  // Define the list of contract types
  List<String> _contractTypes = ['CLT', 'PJ', 'admin'];
  late String _contractType;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with the current user data
    _nameController = TextEditingController(text: widget.user['nome']);
    _emailController = TextEditingController(text: widget.user['email']);
    _cpfController = TextEditingController(text: widget.user['cpf']);
    _passwordController = TextEditingController(
        text: widget.user['password'] ??
            ''); // Use empty string if password is null
    _contractType = widget.user['contractType'] ??
        'CLT'; // Default to 'CLT' if contractType is null
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to delete the employee
  Future<void> _deleteFuncionario() async {
    // Show confirmation dialog
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Funcionário'),
          content: const Text(
              'Você tem certeza de que deseja excluir este funcionário?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No, do not delete
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, delete
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    // If confirmed, proceed with deletion
    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excluindo funcionário...')),
      );

      final response = await deleteUser(widget.user[
          'cpf']); // Assuming deleteUser is defined in your user_queries.dart file

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // Close the editing page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Houve um erro ao excluir o funcionário')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Funcionário'),
        backgroundColor: const Color(0xFF832f30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Name input
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              // Email input
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
              // CPF input
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CPF';
                  }
                  return null;
                },
              ),
              // Contract Type Dropdown
              DropdownButtonFormField<String>(
                value: _contractType, // Bind to the selected contract type
                decoration:
                    const InputDecoration(labelText: 'Tipo de Contrato'),
                items: _contractTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _contractType = newValue!;
                  });
                },
                validator: (value) {
                  // Ensure the selected value is valid
                  if (value == null || !_contractTypes.contains(value)) {
                    return 'Por favor, selecione um tipo de contrato';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Submit Button (Save)
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Atualizando funcionário...')),
                    );
                    final response = await updateUserAdmin(
                        _cpfController.text,
                        _emailController.text,
                        _contractType,
                        _nameController.text);

                    if (response.statusCode == 200) {
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Houve um erro na atualização')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF832f30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Delete Button
              ElevatedButton(
                onPressed: _deleteFuncionario, // Trigger the delete function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Excluir Funcionário',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
