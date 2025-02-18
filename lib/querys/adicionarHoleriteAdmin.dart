import 'dart:convert';

import 'package:http/http.dart' as http;
import '../screens/jwt_token.dart';

Future<http.Response> adicionarHoleritesAdmin(int mes, int ano, String cpf_usuario, String caminho_documento) async {
  print("caminho_documento: $caminho_documento");
  var request = http.MultipartRequest('POST', Uri.parse('http://localhost:3000/api/arquivo/upload'));
  request.headers['Authorization'] = token;
  request.files.add(await http.MultipartFile.fromPath('file', caminho_documento));
  request.fields['cpf_usuario'] = cpf_usuario;
  var responsea = await request.send();
  var responseBody = await responsea.stream.bytesToString();

  print(responseBody);

  int caminho = json.decode(responseBody)["caminho"];

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
      "caminho_documento": caminho,
    }),
  );
  return response;
}