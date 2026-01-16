import 'package:http/http.dart' as http;
import 'dart:convert';

class Purches {
  final String username;
  final String profilePic;
  final String content;
  final double prize;
  final String mediaPath1;
  final String? mediaPath2;
  final String? mediaPath3;
  final String? mediaPath4;
  final String? facade;
  final int? roomNum;
  final int? bathromNum;
  final double? area;
  final String? condation;
  final int? floorNum;
  final String cityName;
  final String addressName;
  final String typeName;

  Purches({
    required this.username,
    required this.profilePic,
    required this.content,
    required this.prize,
    required this.mediaPath1,
    this.mediaPath2,
    this.mediaPath3,
    this.mediaPath4,
    this.facade,
    this.roomNum,
    this.bathromNum,
    this.area,
    this.condation,
    this.floorNum,
    required this.cityName,
    required this.addressName,
    required this.typeName,
  });

  factory Purches.fromJson(Map<String, dynamic> json) {
    return Purches(
      username: json['username'] ?? '',
      profilePic: json['profile_pic'] ?? '',
      content: json['content'] ?? '',
      prize:
          double.tryParse(json['prize']?.toString() ?? '0') ??
          0.0, // Fix for string prize
      mediaPath1: json['media_path1'] ?? '',
      mediaPath2: json['media_path2'],
      mediaPath3: json['media_path3'],
      mediaPath4: json['media_path4'],
      facade: json['facade'],
      roomNum: json['room_num'],
      bathromNum:
          json['bathroom_num'], // ✅ FIXED: 'bathroom_num' not 'bathrom_num'
      area: json['area'] != null ? (json['area'] as num).toDouble() : null,
      condation: json['condation'],
      floorNum: json['floor_num'],
      cityName: json['city_name'] ?? '',
      addressName: json['address_name'] ?? '',
      typeName: json['type_name'] ?? '',
    );
  }
}

Future<List<Purches>> fetchPurches(String username) async {
  final url = Uri.parse('https://api.bodaqarat.com/purches?username=$username');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    final List<dynamic> list = data['purchases'];
    return list.map((json) => Purches.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load purchases');
  }
}
