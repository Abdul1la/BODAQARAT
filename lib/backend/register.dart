import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterResult {
  final bool success;
  final String message; 
  final String? field;

  RegisterResult({required this.success, required this.message, this.field});
}

Future<RegisterResult> registerUser({
  required String username,
  required String password,
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
}) async {
  try {
    username = username.trim();
    email = email.trim();
    phone = phone.trim();

    final url = Uri.parse('https://api.bodaqarat.com/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'email': email,
        'phone': phone,
      }),
    );

    final body = json.decode(response.body);

    if (response.statusCode == 200) {
      final status = body['status'];
      final field = body['field'] as String?;
      final messageFromApi = body['message'] ?? "Unknown error";

      // Build human readable message
      String readableMessage = messageFromApi;

      if (field == "username") {
        readableMessage = "Username is already taken";
      } else if (field == "email") {
        if (messageFromApi == "Invalid email domain") {
          readableMessage = "Email domain does not exist";
        } else {
          readableMessage = "Email is already registered";
        }
      } else if (field == "phone") {
        readableMessage = "Phone number is already in use";
      }

      return RegisterResult(
        success: status == "success",
        message: readableMessage,
        field: field,
      );
    }

    // 500 internal backend error
    if (body is Map && body.containsKey("detail")) {
      return RegisterResult(
        success: false,
        message: body["detail"],
      );
    }

    return RegisterResult(
      success: false,
      message: "Server error: ${response.statusCode}",
    );

  } catch (e) {
    return RegisterResult(
      success: false,
      message: "Connection error: $e"
    );
  }
}
