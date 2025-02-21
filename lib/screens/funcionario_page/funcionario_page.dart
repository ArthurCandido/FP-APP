import 'package:flutter/material.dart';
import 'package:fp_app/screens/crud_funcionario/user_queries.dart';

class FuncionarioPage extends StatefulWidget {
  final Map<String, dynamic>? user;

  const FuncionarioPage({super.key, this.user});

  @override
  _FuncionarioPageState createState() => _FuncionarioPageState();
}

class _FuncionarioPageState extends State<FuncionarioPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final MaskedTextController _cpfController = MaskedTextController(mask: '000.000.000-00');
  final TextEditingController _passwordController = TextEditingController();

  final List<String> _contractTypes = ['CLT', 'PJ'];
  String _contractType = 'CLT';

  // Função para validar o nome
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o nome';
    }
    // Regex para validar o nome (apenas letras)
    String pattern = r'^[a-zA-Z\s]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Por favor, insira um nome válido (apenas letras)';
    }
    return null;
  }

  // Função para validar o email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o email';
    }
    // Regex para validar o email
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }

  // Função para validar o CPF
  String? validateCPF(String? value) {
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

  // Função para validar a senha
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a senha';
    }
    if (value.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Funcionários',
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
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: validateName,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: validateEmail,
                  ),
                  TextFormField(
                    controller: _cpfController,
                    decoration: const InputDecoration(labelText: 'CPF'),
                    validator: validateCPF,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: validatePassword,
                  ),
                  DropdownButtonFormField<String>(
                    value: _contractType,
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
                      if (value == null || !_contractTypes.contains(value)) {
                        return 'Por favor, selecione um tipo de contrato';
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Cadastrando funcionário...')),
                        );
                        final response = await createUser(
                          _nameController.text,
                          _cpfController.text,
                          _emailController.text,
                          _passwordController.text,
                          _contractType,
                        );

                        if (response.statusCode == 200) {
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Houve um erro no cadastro')),
                          );
                        }
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
                      'Cadastrar',
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
