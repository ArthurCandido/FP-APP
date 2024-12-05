import 'package:flutter/material.dart';
import 'package:fp_app/screens/login_page/login_page.dart'; // Certifique-se de que este caminho está correto

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to fooPay'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
                'assets/images/FPlogo.png'), // Substitua pelo caminho da sua imagem
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Login com Email'),
            ),
          ],
        ),
      ),
    );
  }
}
