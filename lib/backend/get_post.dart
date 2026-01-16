import 'dart:convert';
import 'package:http/http.dart' as http;

class Posts {
  final String username;
  final String content;
  final String? phone_num;
  final String media_path1;
  final String? media_path2;
  final String? media_path3;
  final String? media_path4;
  final String price;
  final String location;
  final int area;
  final String facade;
  final String condetion;
  final int floor_num;
  final int room_num;
  final int bathroom_num;
  final String created_at;
  final String city;
  final String address;
  final String type_name;
  final bool is_available;
  final int post_id;

  Posts({
    required this.username,
    required this.content,
    this.phone_num,
    required this.media_path1,
    this.media_path2,
    this.media_path3,
    this.media_path4,
    required this.price,
    required this.location,
    required this.area,
    required this.facade,
    required this.condetion,
    required this.floor_num,
    required this.room_num,
    required this.bathroom_num,
    required this.created_at,
    required this.city,
    required this.address,
    required this.type_name,
    required this.is_available,
    required this.post_id,
  });
  // ---------------------------
  //       ADD THIS METHOD
  // ---------------------------
  Posts copyWith({bool? is_available}) {
    return Posts(
      username: username,
      content: content,
      phone_num: phone_num,
      media_path1: media_path1,
      media_path2: media_path2,
      media_path3: media_path3,
      media_path4: media_path4,
      price: price,
      location: location,
      area: area,
      facade: facade,
      condetion: condetion,
      floor_num: floor_num,
      room_num: room_num,
      bathroom_num: bathroom_num,
      created_at: created_at,
      city: city,
      address: address,
      type_name: type_name,
      is_available: is_available ?? this.is_available,
      post_id: post_id,
    );
  }

  factory Posts.fromJson(Map<String, dynamic> json) {
    List images = json['images'] ?? [];

    return Posts(
      username: json['username'],
      content: json['content'],
      phone_num: json['phone_num'],
      media_path1: images.isNotEmpty ? images[0] : "",
      media_path2: images.length > 1 ? images[1] : null,
      media_path3: images.length > 2 ? images[2] : null,
      media_path4: images.length > 3 ? images[3] : null,
      price: json['prize'],
      location: json['location'],
      area: json['area'],
      facade: json['facade'],
      condetion: json['condation'],
      floor_num: json['floor_num'],
      room_num: json['room_num'],
      bathroom_num: json['bathroom_num'],
      created_at: json['created_at'],
      city: json['city_name'],
      address: json['address_name'],
      type_name: json['type_name'],
      is_available: json['is_available'],
      post_id: json['post_id'],
    );
  }

  int get length => media_path1.isNotEmpty ? 1 : 0;
}

class PostsInDB {
  final String username;
  final String first_name;
  final String last_name;
  final String profile_pic;
  final String phone_num;
  final int post_id;
  final String content;
  final String media_path1;
  final String? media_path2;
  final String? media_path3;
  final String? media_path4;
  final String prize;
  final String location;
  final int area;
  final String facade;
  final String condation;
  final int floor_num;
  final int room_num;
  final int bathroom_num;
  final String created_at;
  final String city;
  final String address;
  final String type_name;
  final bool is_available;

  PostsInDB({
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.profile_pic,
    required this.phone_num,
    required this.post_id,
    required this.content,
    required this.media_path1,
    this.media_path2,
    this.media_path3,
    this.media_path4,
    required this.prize,
    required this.location,
    required this.area,
    required this.facade,
    required this.condation,
    required this.floor_num,
    required this.room_num,
    required this.bathroom_num,
    required this.created_at,
    required this.city,
    required this.address,
    required this.type_name,
    required this.is_available,
  });

  factory PostsInDB.fromJson(Map<String, dynamic> json) {
    List images = json['images'] ?? [];
    return PostsInDB(
      username: json['username'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      profile_pic: json['profile_pic'],
      phone_num: json['phone_num'],
      post_id: json['post_id'],
      content: json['content'],
      media_path1: images.isNotEmpty ? images[0] : "",
      media_path2: images.length > 1 ? images[1] : null,
      media_path3: images.length > 2 ? images[2] : null,
      media_path4: images.length > 3 ? images[3] : null,
      prize: json['prize'],
      location: json['location'],
      area: json['area'],
      facade: json['facade'],
      condation: json['condation'],
      floor_num: json['floor_num'],
      room_num: json['room_num'],
      bathroom_num: json['bathroom_num'],
      created_at: json['created_at'],
      city: json['city_name'],
      address: json['address_name'],
      type_name: json['type_name'],
      is_available: json['is_available'],
    );
  }

  void operator [](String other) {}
}

// get post by username
Future<List<Posts>> fetchPost(String username, String lang) async {
  final url = Uri.parse("https://api.bodaqarat.com/posts/$username?lang=$lang");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>; // <-- List not Map
    return data.map((post) => Posts.fromJson(post)).toList();
  } else {
    throw Exception("Failed to load post");
  }
}

// get all posts count from database for random post display
Future<int> fetchPostsCount(String username) async {
  final url = Uri.parse("https://api.bodaqarat.com/post_count/$username");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data["post_count"] as int;
  } else {
    throw Exception("Failed to load posts count");
  }
}

// get all posts from database
Future<List<PostsInDB>> fetchAllPosts(String lang, String username) async {
  final url = Uri.parse(
    "https://api.bodaqarat.com/all_posts?lang=$lang&username=$username",
  );
  final response = await http.get(url);

  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((post) => PostsInDB.fromJson(post)).toList();
    } catch (e) {
      print("Error parsing JSON: $e");
      return [];
    }
  } else {
    print("Failed to fetch posts: ${response.statusCode}");
    return [];
  }
}
