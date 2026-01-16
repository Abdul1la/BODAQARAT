import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendEmailRequest({
  required String username,
  required String userEmail,
  required String preferredDate,
  required String preferredTime,
  required String position,
  required String note,
}) async {
  final url = Uri.parse("https://api.bodaqarat.com/email");

  final body = {
    "username": username,
    "user_email": userEmail,
    "preferred_date": preferredDate,
    "preferred_time": preferredTime,
    "position": position,
    "note": note,
  };

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body),
  );

  print("Status: ${response.statusCode}");
  print("Response: ${response.body}");
}
