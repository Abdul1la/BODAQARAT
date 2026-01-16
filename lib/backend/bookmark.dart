import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<int>> fetchBookmarks(String username) async {
  final url = Uri.parse('https://api.bodaqarat.com/bookmarks/$username');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<int> bookmarkedPostIds = List<int>.from(data['bookmarked_posts']);
    return bookmarkedPostIds;
  } else {
    throw Exception('Failed to load bookmarks');
  }
}

Future<void> addBookmark(String username, int postId) async {
  final url = Uri.parse('https://api.bodaqarat.com/bookmarks/$username/$postId');
  final response = await http.post(url);

  if (response.statusCode == 200) {
    print('Bookmark added successfully');
  } else {
    throw Exception('Failed to add bookmark');
  }
}

Future<void> removeBookmark(String username, int postId) async {
  final url = Uri.parse('https://api.bodaqarat.com/bookmarks/$username/$postId');
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    print('Bookmark removed successfully');
  } else {
    throw Exception('Failed to remove bookmark');
  }
}
