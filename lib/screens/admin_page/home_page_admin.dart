import 'package:flutter/material.dart';
import 'package:fp_app/screens/funcionario_page/funcionario_page.dart';
import 'package:fp_app/screens/funcionario_page/funcionario_editing_page.dart';
import 'package:fp_app/screens/welcome_page/welcome_page.dart';
import 'package:fp_app/screens/holerite_page/add_holerite_page.dart';
import 'package:fp_app/screens2/adminHolerites.dart';
import 'dart:convert';
import '../crud_funcionario/user_queries.dart';

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
      final response = await getUser("", "", "", "");
      if (response.statusCode == 200) {
        setState(() {
          users = jsonDecode(response.body);
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
        title: const Text('Home Admin', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF832f30),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: fetchUsers,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FuncionarioEditingPage(user: user),
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
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "FAB FuncionarioPage",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FuncionarioPage(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF832f30),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 70),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "FAB AdminHolerites",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHolerites(),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF832f30),
                child: const Icon(Icons.receipt, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
