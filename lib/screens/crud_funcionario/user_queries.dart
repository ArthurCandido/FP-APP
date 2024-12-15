import 'package:http/http.dart' as http;
import '../jwt_token.dart';
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


Future<http.Response> getUser(String cpf, String email, String tipo) async {
  final Map<String, String> queryP = {'cpf': cpf, 'email': email, 'tipo': tipo};
  final url = Uri.http('localhost:3000', '/api/admin/user', queryP);

  return http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );
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
