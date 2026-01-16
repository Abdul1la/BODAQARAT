import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String username;
  final String email;
  final String phoneNum;
  final String firstName;
  final String lastName;
  final String bio;
  final String? profilePic;
  final String? backPic;
  final String? city;
  final String? district;

  User({
    required this.username,
    required this.email,
    required this.phoneNum,
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.profilePic,
    this.backPic,
    this.city,
    this.district,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      phoneNum: json['phone_num'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      bio: json['bio'] ?? "",
      profilePic: json['profile_pic'],
      backPic: json['back_pic'],
      city: json['city'],
      district: json['district'],
    );
  }
}

Future<User?> fetchUser(String username) async {
  final url = Uri.parse(
    "https://api.bodaqarat.com/users/$username",
  ); // localhost:8000 for emulator
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // If backend returns {"error": "User not found"}
    if (data is Map && data.containsKey("error")) {
      return null;
    }

    User userInfo = User.fromJson(data);

    return userInfo;
  } else {
    throw Exception("Failed to load user");
  }
}
