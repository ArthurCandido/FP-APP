import 'dart:convert';

import 'package:fp_app/atualizar.dart';
import 'package:http/http.dart' as http;
import '../screens/jwt_token.dart';

Future<http.Response> alterarHoleritesAdmin(int mes, int ano, String cpf_usuario, int caminho_documento) async {
  final response = await http.put(
    Uri.parse("http://localhost:3000/api/admin/holerite/$cpf_usuario/$mes/$ano"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
    body: jsonEncode({
      "caminho_documento": caminho_documento,
    }),
  );
  if(response.statusCode == 200){
    atualizarAdminHolerites();
  }
  return response;
}