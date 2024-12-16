import 'package:http/http.dart' as http;
import '../jwt_token.dart';
import 'dart:convert';

Future<http.Response> createUser(
    String nome, String cpf, String email, String senha, String tipo) async {
  return http.post(
    Uri.parse('http://localhost:3000/api/admin/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
    body: jsonEncode(<String, String>{
      "cpf": cpf,
      "email": email,
      "senha": senha,
      "tipo": tipo,
      "nome": nome,
    }),
  );
}

Future<http.Response> deleteUser(String cpf) async {
  return http.delete(
    Uri.parse('http://localhost:3000/api/admin/user/$cpf'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );
}

Future<http.Response> getUser(
    String cpf, String email, String tipo, String nome) async {
  final Map<String, String> queryP = {
    'cpf': cpf,
    'email': email,
    'tipo': tipo,
    'nome': nome
  };
  final url = Uri.http('localhost:3000', '/api/admin/user', queryP);

  return http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );
}

Future<http.Response> updateUserAdmin(
    String cpf, String email, String tipo, String nome) async {
  return http.put(
    Uri.parse('http://localhost:3000/api/admin/user/$cpf'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "tipo": tipo,
      "nome": nome,
    }),
  );
}


Future<http.Response> updateUserByFunc(
    String cpf, String email, String senha, String tipo, String nome) async {
  return http.put(
    Uri.parse('http://localhost:3000/api/admin/user/$cpf'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "senha": senha,
      "tipo": tipo,
    }),
  );
}
