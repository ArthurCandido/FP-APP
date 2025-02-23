import 'dart:convert';
import 'package:fp_app/global.dart';
import 'package:http/http.dart' as http;
import '../screens/jwt_token.dart';

Future<http.Response> loginUserEmail(String email, String senha) async {
  final response = await http.post(
    Uri.parse("http://localhost:3000/api//user/autenticaremail"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "email": email,
      "senha": senha,
    }),
  );
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    token = json['token'];
    Gtoken = token;
  }
  return response;
}

Future<http.Response> loginUserCpf(String cpf, String senha) async {
  final response = await http.post(
    Uri.parse("http://localhost:3000/api//user/autenticaremail"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "cpf": cpf,
      "senha": senha,
    }),
  );
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    token = json['token'];
  }
  return response;
}
