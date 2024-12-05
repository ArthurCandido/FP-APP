import 'package:flutter/material.dart';
import 'screens/welcome_page/welcome_page.dart'; // Certifique-se de que este caminho está correto

void main() => runApp(FooPayApp());

class FooPayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fooPay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}
