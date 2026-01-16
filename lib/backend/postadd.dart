import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PostsAPI {
  static const String baseUrl = "https://api.bodaqarat.com";

  /// Upload a new post with up to 4 images
  static Future<Map<String, dynamic>> uploadProperty({
    required String username,
    required String content,
    required String prize,
    required String location,
    required int? area,
    required String facade,
    required String condation,
    required int? floorNum,
    required int? roomNum,
    required int? bathroomNum,
    required int cityId,
    required int addressId,
    required int stateId,
    required List<String> imagePaths, // list of file paths
  }) async {
    final uri = Uri.parse("$baseUrl/postadd");
    final request = MultipartRequest("POST", uri);

    // =======================
    // Form data
    // =======================
    request.fields["username"] = username;
    request.fields["content"] = content;
    request.fields["prize"] = prize;
    request.fields["location"] = location;
    request.fields["area"] = area?.toString() ?? "";
    request.fields["facade"] = facade;
    request.fields["condation"] = condation;
    request.fields["floor_num"] = floorNum?.toString() ?? "";
    request.fields["room_num"] = roomNum?.toString() ?? "";
    request.fields["bathroom_num"] = bathroomNum?.toString() ?? "";
    request.fields["city"] = cityId.toString();
    request.fields["address_name"] = addressId.toString();
    request.fields["state"] = stateId.toString();

    // =======================
    // Images (max 4)
    // =======================
    for (int i = 0; i < imagePaths.length && i < 4; i++) {
      request.files.add(
        await http.MultipartFile.fromPath("images", imagePaths[i]),
      );
    }

    final streamedResponse = await request.send();
    final response = await streamedResponse.stream.bytesToString();

    return jsonDecode(response);
  }
}

// post delete function calling backend api
Future<bool> deletePost(int postId, String username) async {
  final url = Uri.parse("https://api.bodaqarat.com/postdelete/$postId&$username");
  final response = await http.delete(url);
  return response.statusCode == 200;
}
