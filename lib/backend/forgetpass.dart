import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "https://api.bodaqarat.com";

Future<bool> requestPasswordReset(String username) async {
  final uri = Uri.parse("$baseUrl/auth/request_reset");

  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"username": username.trim().toLowerCase()}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["status"] == "success";
  } else {
    throw Exception("Password reset request failed");
  }
}
