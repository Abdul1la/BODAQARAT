import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchUserInfo(String username) async {
  final response = await http.get(
    Uri.parse("https://api.bodaqarat.com/GetUserInfo?username=$username"),
  );

  final body = jsonDecode(response.body);
  print(response.body);
  if (body["status"] == "success") {
    return body["data"];
  } else {
    throw Exception("Failed to load data");
  }
}

// sent user info to the backend to update it
Future<Map<String, dynamic>> updateUserRequest({
  required String username,
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
  String? bio,
  File? profileImage,
}) async {
  print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  print("📤 SENDING TO BACKEND:");
  print("   Username: $username");
  print("   Profile Image Path: ${profileImage?.path}");
  print("   Profile Image Exists: ${profileImage?.existsSync()}");

  if (profileImage != null) {
    final fileSize = await profileImage.length();
    print("   Profile Image Size: $fileSize bytes");
    print("   Profile Image Name: ${profileImage.path.split('/').last}");
  }
  print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

  final url = Uri.parse("https://api.bodaqarat.com/UpdateUserMobile");

  final request = http.MultipartRequest("POST", url);

  // Text fields
  request.fields["username"] = username;
  request.fields["first_name"] = firstName;
  request.fields["last_name"] = lastName;
  request.fields["email"] = email;
  request.fields["phone"] = phone;
  request.fields["bio"] = bio ?? "";

  // Optional image
  if (profileImage != null) {
    final multipartFile = await http.MultipartFile.fromPath(
      "profilePic",
      profileImage.path,
    );

    print("📎 Adding multipart file:");
    print("   Field name: profile_pic");
    print("   File length: ${multipartFile.length}");
    print("   Content type: ${multipartFile.contentType}");

    request.files.add(multipartFile);
  }

  print("🚀 Sending request...");

  // Send request
  final response = await request.send();

  print("📥 Response status code: ${response.statusCode}");

  final responseBody = await response.stream.bytesToString();

  print("📥 Response body: $responseBody");
  print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

  final body = jsonDecode(responseBody);

  return body;
}

// Delete user account
Future<Map<String, dynamic>> deleteAccount(String username) async {
  try {
    final url = Uri.parse("https://api.bodaqarat.com/delete_account/$username");
    
    final response = await http.delete(url);
    
    final body = jsonDecode(response.body);
    
    if (response.statusCode == 200 && body["status"] == "success") {
      return {"success": true, "message": body["message"] ?? "Account deleted successfully"};
    } else {
      return {"success": false, "message": body["message"] ?? "Failed to delete account"};
    }
  } catch (e) {
    return {"success": false, "message": "Error: $e"};
  }
}