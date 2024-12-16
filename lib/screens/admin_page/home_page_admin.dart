import 'package:flutter/material.dart';
import 'package:fp_app/screens/funcionario_page/funcionario_page.dart';
import 'package:fp_app/screens/funcionario_page/funcionario_editing_page.dart'; // Import the editing page
import 'package:fp_app/screens/welcome_page/welcome_page.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;
import '../crud_funcionario/user_queries.dart'; // Replace with the actual file path for getUser

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await getUser(
          "", "", "", ""); // Fetch all users with empty query params
      if (response.statusCode == 200) {
        setState(() {
          users = jsonDecode(response.body); // Decode the JSON response
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Admin'),
        backgroundColor: const Color(0xFF832f30),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          // Reload button in the app bar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUsers, // Refresh users when pressed
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text('No users found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to FuncionarioEditingPage instead of FuncionarioPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FuncionarioEditingPage(user: user),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Nome: ${user['nome']}',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 8),
                                  Text('Email: ${user['email']}',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 8),
                                  Text('CPF: ${user['cpf']}',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 8),
                                  Text('Tipo de Contrato: ${user['tipo']}',
                                      style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      // Add User Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to FuncionarioPage when the "Add User" button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FuncionarioPage(), // Navigate to the page for adding a new user
            ),
          );
        },
        backgroundColor: const Color(0xFF832f30),
        child: const Icon(Icons.add),
      ),
    );
  }
}
