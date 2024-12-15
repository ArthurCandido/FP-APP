import 'package:flutter/material.dart';
import 'screens/welcome_page/welcome_page.dart'; // Certifique-se de que este caminho está correto

void main() => runApp(const FooPayApp());

class FooPayApp extends StatelessWidget {
  const FooPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fooPay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
