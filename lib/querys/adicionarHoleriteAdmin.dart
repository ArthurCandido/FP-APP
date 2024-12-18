import 'dart:convert';

import 'package:http/http.dart' as http;
import '../screens/jwt_token.dart';

Future<http.Response> adicionarHoleritesAdmin(int mes, int ano, String cpf_usuario, int caminho_documento) async {
  final response = await http.post(
    Uri.parse("http://localhost:3000/api/admin/holerite"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
    body: jsonEncode({
      "mes": mes,
      "ano": ano,
      "cpf_usuario": cpf_usuario,
      "caminho_documento": caminho_documento,
    }),
  );
  return response;
}