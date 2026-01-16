// login page from front-end to back-end
import 'dart:convert';
import 'package:aqarat_flutter_project/global.dart';
import 'package:http/http.dart' as http;

class SubscriptionInfo {
  final String status;
  final int daysLeft;
  final String? endDate;

  SubscriptionInfo({
    required this.status,
    required this.daysLeft,
    this.endDate,
  });
}

class LoginResult {
  final bool success;
  final String message;
  final int? accountId;
  final String? username;
  final String? userEmail;
  final SubscriptionInfo? subscription;

  LoginResult({
    required this.success,
    required this.message,
    this.accountId,
    this.username,
    this.userEmail,
    this.subscription,
  });
}

Future<LoginResult> loginUser(String username, String password) async {
  final url = Uri.parse('https://api.bodaqarat.com/login');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Parse subscription data
      final subData = data["subscription"];
      SubscriptionInfo? subscription;

      if (subData != null) {
        subscription = SubscriptionInfo(
          status: subData["status"] ?? "none",
          daysLeft: subData["days_left"] ?? 0,
          endDate: subData["end_date"],
        );
      }

      return LoginResult(
        success: true,
        message: "Login successful",
        accountId: data["account_id"],
        username: data["username"],
        userEmail: data["user_email"],
        subscription: subscription,
      );
    }

    if (response.statusCode == 401) {
      return LoginResult(
        success: false,
        message: "Invalid username or password",
      );
    }

    return LoginResult(
      success: false,
      message: "Server error: ${response.statusCode}",
    );
  } catch (e) {
    return LoginResult(success: false, message: "Connection error: $e");
  }
}
