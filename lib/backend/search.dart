import 'package:http/http.dart' as http;
import 'dart:convert';

class Address {
  final int addressId;
  final String addressName;

  Address({required this.addressId, required this.addressName});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['address_id'],
      addressName: json['address_name'],
    );
  }
}

class City {
  final int cityId;
  final String cityName;
  final List<Address> addresses;

  City({required this.cityId, required this.cityName, required this.addresses});

  factory City.fromJson(Map<String, dynamic> json) {
    var list = json['addresses'] as List;
    List<Address> addressesList = list.map((i) => Address.fromJson(i)).toList();

    return City(
      cityId: json['city_id'],
      cityName: json['city_name'],
      addresses: addressesList,
    );
  }
}

Future<List<City>> fetchLocations({String? lang}) async {
  String url = 'https://api.bodaqarat.com/locations';
  if (lang != null) {
    url += '?lang=$lang';
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    var citiesJson = data['locations'] as List;
    return citiesJson.map((c) => City.fromJson(c)).toList();
  } else {
    throw Exception('Failed to load locations');
  }
}

// State type ---------------------------------

class StateType {
  final int typeId;
  final String typeName;

  StateType({required this.typeId, required this.typeName});

  factory StateType.fromJson(Map<String, dynamic> json) {
    return StateType(typeId: json['type_id'], typeName: json['type_name']);
  }
}

Future<List<StateType>> fetchStateTypes(String lang) async {
  final url = 'https://api.bodaqarat.com/state_type?lang=$lang';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    var typesJson = data['state_types'] as List;
    return typesJson.map((t) => StateType.fromJson(t)).toList();
  } else {
    throw Exception('Failed to load state types');
  }
}

// Search results ----------------------------

Future<String> performSearch(
  String? city,
  String? address,
  String? stateType,
  String? sortBy,
) async {
  // Create parameters map and encode all values
  final params = <String, String>{};

  if (city != null && city.isNotEmpty) {
    params['city'] = city;
  }
  if (address != null && address.isNotEmpty) {
    params['address'] = address;
  }
  if (stateType != null && stateType.isNotEmpty) {
    params['state_type'] = stateType;
  }
  if (sortBy != null && sortBy.isNotEmpty) {
    params['sort_by'] = sortBy;
  }

  // Use Uri.https which automatically handles encoding
  final uri = Uri.https('bodaqarat.com', '/search', params);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['message'];
  } else {
    print('HTTP Error: ${response.statusCode}');
    print('Response: ${response.body}');
    throw Exception('Failed to perform search: ${response.statusCode}');
  }
}

// Sort options -------------------------------
class MiniOption {
  final String postId;
  final String username;
  final String city;
  final String profilePic;
  final String mediaPath1;
  final String prize;
  final String address;
  final String stateType;
  final String bathrooms;
  final String bedrooms;
  final String area;

  MiniOption({
    required this.postId,
    required this.username,
    required this.city,
    required this.profilePic,
    required this.mediaPath1,
    required this.prize,
    required this.address,
    required this.stateType,
    required this.bathrooms,
    required this.bedrooms,
    required this.area,
  });

  factory MiniOption.fromJson(Map<String, dynamic> json) {
    return MiniOption(
      postId: json['post_id'].toString(),
      username: json['username'],
      city: json['city_name'],
      profilePic: json['profile_pic'],
      mediaPath1: json['media_path1'],
      prize: json['prize'].toString(),
      address: json['address_name'],
      stateType: json['state_type'],
      bedrooms: json['room_num'].toString(),
      bathrooms: json['bathroom_num'].toString(),
      area: json['area'].toString(),
    );
  }
}

Future<List<MiniOption>> fetchSortOptions(
  String lang, {
  String? city,
  String? address,
  String? stateType,
  String? sortBy,
}) async {
  // Build URL properly without null values
  final params = {
    'lang': lang,
    if (city != null && city.isNotEmpty) 'city': city,
    if (address != null && address.isNotEmpty) 'address': address,
    if (stateType != null && stateType.isNotEmpty) 'state_type': stateType,
    if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
  };

  final uri = Uri.parse(
    'https://api.bodaqarat.com/sort_options',
  ).replace(queryParameters: params);

  print('API Call: ${uri.toString()}'); // Debug log

  final response = await http.get(uri);

  print('Response Status: ${response.statusCode}'); // Debug log
  print('Response Body: ${response.body}'); // Debug log

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Parsed Data: $data'); // Debug log

    var optionsJson = data['sort_options'] as List;
    return optionsJson.map((o) => MiniOption.fromJson(o)).toList();
  } else {
    throw Exception('Failed to load sort options: ${response.statusCode}');
  }
}
