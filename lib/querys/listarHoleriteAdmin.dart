import 'package:http/http.dart' as http;
import '../screens/jwt_token.dart';

Future<http.Response> listarHoleritesAdmin() async {
  final response = await http.get(
    Uri.parse("http://localhost:3000/api/admin/holerite"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': token
    },
  );
  return response;
}