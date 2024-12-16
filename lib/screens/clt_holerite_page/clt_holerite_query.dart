import 'package:http/http.dart' as http;
import '../jwt_token.dart';
import 'dart:convert';

Future<http.Response> createHoleriteAdmin(
    int mes, int ano, String cpf, int caminhoDocumento) {
  return http.post(
    Uri.parse('http://localhost:3000/api/admin/holerite'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
    body: jsonEncode(<String, dynamic>{
      "cpf_usuario": cpf,
      "mes": mes,
      "ano": ano,
      "caminho_documento": caminhoDocumento,
    }),
  );
}

Future<http.Response> getHoleriteAdmin(int mes, int ano, String cpf) async {
  final Map<String, dynamic> queryP = {'cpf_usuario': cpf, 'ano': ano, 'mes': mes};
  final url = Uri.http('localhost:3000', '/api/admin/holerite', queryP);

  return http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );
}

Future<http.Response> updateUser(String cpf, int mes, int ano, int caminhoDocumento){
    return http.put(
    Uri.parse('http://localhost:3000/api/admin/holerite/$cpf/$mes/$ano'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
    body: jsonEncode(<String, dynamic>{
      "caminho_documento": caminhoDocumento
    }),
  );
}

Future<http.Response> deleteUser(String cpf, int mes, int ano){
    return http.delete(
    Uri.parse('http://localhost:3000/api/admin/holerite/$cpf/$mes/$ano'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );
}

Future<http.Response> getHoleriteCLT(int mes, int ano, String cpf) async {
  final Map<String, dynamic> queryP = {'ano': ano, 'mes': mes};
  final url = Uri.http('localhost:3000', '/api/admin/holerite', queryP);

  return http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );
}