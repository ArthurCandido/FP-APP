import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fp_app/components/PopupError.dart';
import 'package:fp_app/components/PopupProgress.dart';
import 'package:fp_app/querys/login_query.dart';
import 'package:fp_app/screens/admin_page/home_page_admin.dart';
import 'package:fp_app/screens/home_page_clt/home_page_clt.dart';
import 'package:fp_app/screens/nfe_page/nfe_page.dart';
import 'package:fp_app/screens2/cltHolerites.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String senha = "";
  bool _obscureText = true;

  // Função para validar o email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um email';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: validateEmail,
                    onSaved: (texto) {
                      email = texto!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insira sua senha';
                      }
                      return null;
                    },
                    onSaved: (texto) {
                      senha = texto!;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const PopupProgress();
                          },
                        );

                        var response = await loginUserEmail(email, senha);

                        Navigator.of(context).pop();

                        if (response.statusCode == 200) {
                          String tipo = jsonDecode(response.body)["tipo"];
                          Map<String, dynamic> user = jsonDecode(response.body);
                          switch (tipo) {
                            case 'admin':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePageAdmin()),
                              );
                              break;
                            case 'CLT':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CltHolerites()),
                              );
                              break;
                            case 'PJ':
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NfePage()),
                              );
                              break;
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PopupError(
                                  error: jsonDecode(response.body)["message"]);
                            },
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF832f30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Login',
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