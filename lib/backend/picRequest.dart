import 'package:http/http.dart' as http;
import 'dart:convert';

// Function to send emaill
Future<void> sendEmail(String email, String subject, String body) async {
  final url = Uri.parse('https://api.bodaqarat.com/send');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'to': email, 'subject': subject, 'body': body}),
  );

  if (response.statusCode == 200) {
    print('Email sent successfully');
  } else {
    print('Failed to send email: ${response.body}');
  }
}
