import 'package:http/http.dart' as http;
import '../jwt_token.dart';
import 'user_class.dart';
import 'dart:convert';

Future<http.Response> createUser(
    String cpf, String email, String senha, String tipo) {
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
    }),
  );
}

Future<http.Response> deleteUser(String cpf){
    return http.delete(
    Uri.parse('http://localhost:3000/api/admin/user/$cpf'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );
}


Future<List<User>> getUser(String cpf, String email, String tipo) async {
  try {
    final response =  await http.get(
    Uri.parse('http://localhost:3000/api/admin/user?cpf=$cpf&email=$email&tipo=$tipo'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );
    if (response.statusCode == 200) {
      var userList = jsonDecode(response.body) as List;
      print('Decoded products: $userList'); // Debugging log

      return userList
          .map((json) => User.fromJson(json as Map<String, String>))
          .toList();
    } else {
      throw Exception(
          'Falha ao carregar os usuários, status code: ${response.statusCode}');
    }
  } catch (e) {
    rethrow; // Rethrow to propagate error
  }
}

Future<http.Response> updateUser(String cpf, String email, String senha, String tipo){
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