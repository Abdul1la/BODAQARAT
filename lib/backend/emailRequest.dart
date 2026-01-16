import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductRequestService {
  final String baseUrl = "https://api.bodaqarat.com";

  Future<Map<String, dynamic>> requestProduct({
    required String buyerUsername,
    required int postId,
  }) async {
    final url = Uri.parse("$baseUrl/request_product");

    final body = jsonEncode({
      "buyer_username": buyerUsername,
      "post_id": postId,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": jsonDecode(response.body)["message"],
        };
      } else {
        return {
          "success": false,
          "message":
              jsonDecode(response.body)["detail"] ?? "Something went wrong",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}
