import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchAds() async {
  final response = await http.get(Uri.parse("https://api.bodaqarat.com/ads"));
  List<String> parseAds(String responseBody) {
    final data = jsonDecode(response.body);
    return List<String>.from(data['ads']);
  }

  if (response.statusCode == 200) {
    return parseAds(response.body);
  } else {
    throw Exception('Failed to load ads');
  }
}
