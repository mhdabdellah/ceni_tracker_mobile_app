import 'dart:convert';
import 'package:ceni_scanner/auth/auth_model.dart';
import 'package:ceni_scanner/constant.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    // Get token from SharedPreferences
    // String? token = await AppConstants.getToken();

    // Map<String, dynamic> userLoginData = {
    //   'username': username,
    //   'password': password
    // };
    // String jsonBody = jsonEncode(userLoginData);

    final url = Uri.parse(AppConstants.loginApiUrl);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        // 'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> logout() async {
    final url = Uri.parse(AppConstants.logoutApiUrl);
    final response = await http.post(url);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
    int userId,
    String token,
  ) async {
    String jsonBody = json.encode({
      'user_id': userId,
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    });
    final url = Uri.parse(AppConstants.changePasswordApiUrl);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );
    return json.decode(response.body);
  }

  Future<UserAssignment> getUserAssignment(int userId) async {
    final url = Uri.parse(AppConstants.userAssignmentApiUrl);

    final Map<String, dynamic> requestBody = {'id': userId};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    return UserAssignment.fromMap(responseData);
  }

  // Future<User> getUser(int userId) async {
  //   final url = Uri.parse(AppConstants.userApiUrl);

  //   final Map<String, dynamic> requestBody = {'id': userId};

  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(requestBody),
  //   );

  //   final Map<String, dynamic> responseData = json.decode(response.body);
  //   return User.fromMap(responseData);
  // }
}
