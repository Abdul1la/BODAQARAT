import 'dart:convert';
import 'package:http/http.dart' as http;

// =============================
// Subscription model
// =============================
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

// =============================
// Result of upgrade call
// =============================
class SubscriptionUpgradeResult {
  final bool success;
  final String message;
  final SubscriptionInfo? subscription;

  SubscriptionUpgradeResult({
    required this.success,
    required this.message,
    this.subscription,
  });
}

// =============================
// Upgrade subscription function
// =============================
Future<SubscriptionUpgradeResult> upgradeSubscription(
  String username,
  int accountId,
) async {
  final url = Uri.parse("https://api.bodaqarat.com/subscriptions/activate");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "account_id": accountId}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SubscriptionUpgradeResult(
        success: true,
        message: data["message"] ?? "Subscription activated",
        subscription: null, // backend does not return details
      );
    }

    return SubscriptionUpgradeResult(
      success: false,
      message: data["detail"] ?? "Server error",
    );
  } catch (e) {
    return SubscriptionUpgradeResult(
      success: false,
      message: "Connection error: $e",
    );
  }
}
