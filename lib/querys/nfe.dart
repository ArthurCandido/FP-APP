import 'dart:convert';
import 'package:http/http.dart' as http;
import '../screens/jwt_token.dart';

Future<List<Map<String, dynamic>>> listarNotaFiscal() async {
  final response = await http.get(
    Uri.parse("http://localhost:3000/api/pj/notafiscal/requisitadas"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Falha ao carregar as notas fiscais.');
  }
}

Future<http.Response> enviarNotaFiscal(
    int mes, int ano, String caminhoDocumento) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('http://localhost:3000/api/pj/notafiscal'));
  request.headers['Authorization'] = token;
  request.files
      .add(await http.MultipartFile.fromPath('file', caminhoDocumento));
  request.fields['mes'] = mes.toString();
  request.fields['ano'] = ano.toString();
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  return response;
}


Future<List<Map<String, dynamic>>> listarNotaFiscalAdm() async {
  final response = await http.get(
    Uri.parse("http://localhost:3000/api/admin/notafiscal/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Falha ao carregar as notas fiscais.');
  }
}