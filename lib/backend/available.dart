import 'package:http/http.dart' as http;
import 'dart:convert';

class PostAvailabilityAPI {
  static const String baseUrl = "https://api.bodaqarat.com";

  /// ---------------------------------------------------
  ///  Make Post UNAVAILABLE
  /// ---------------------------------------------------
  static Future<bool> makePostUnavailable(String username, int postId) async {
    final url = Uri.parse("$baseUrl/posts/make_unavailable");

    final body = jsonEncode({"username": username.trim(), "post_id": postId});

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["status"] == "success" ||
            data["status"] == "already_unavailable";
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  /// ---------------------------------------------------
  ///  Make Post AVAILABLE
  /// ---------------------------------------------------
  static Future<bool> makePostAvailable(String username, int postId) async {
    final url = Uri.parse("$baseUrl/posts/make_available");

    final body = jsonEncode({"username": username.trim(), "post_id": postId});

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["status"] == "success";
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
