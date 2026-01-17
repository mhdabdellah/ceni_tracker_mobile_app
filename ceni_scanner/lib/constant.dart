import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstants {
  static const Color primaryColor = Color(0xFF00A95C);

  // static const String _ipAddress = "172.16.51.117";
  // static const String _port = '8000';

  // static const String _apiHost = "http://$_ipAddress:$_port";
  static const String _apiHost =
      "https://ceni-tracking-app.onrender.com/ceniTrackerApi";
  // static const String _apiLocalHost = "http://$_ipAddress:$_port";

  // static const String _apiRemoteHost = "https://tracking.ceni.app";

  // static const bool remoteServerIsActive = false;

  // static const String _apiHost = remoteServerIsActive == true ? _apiRemoteHost : _apiLocalHost;
  // static const String _apiHost = "https://tracking.ceni.app";

  // Define the URL for your Django backend endpoint
  static String markObjectReceivedUrl = '$_apiHost/mark_object_received/';
  static String sendObjectApiUrl = '$_apiHost/mark_object_sended/';
  static String detectObjectApiUrl = '$_apiHost/mark_object_detected/';
  static String alertObjectApiUrl = '$_apiHost/mark_object_alert/';

  // Define the URL for your Django backend endpoint
  static String sendPositionApiUrl =
      '$_apiHost/add_position_to_tracked_object/';
  static String loginApiUrl = '$_apiHost/login/';
  static String logoutApiUrl = '$_apiHost/logout/';
  static String changePasswordApiUrl = '$_apiHost/change-password/';

  // Define the URL for your Django backend endpoint
  // static String loginApiUrl = '$_apiHost/accounts/apis/user_login/';
  // static String logoutApiUrl = '$_apiHost/accounts/apis/user_logout/';
  static String userAssignmentApiUrl =
      '$_apiHost/accounts/apis/get_assignment_by_user_id/';
  static String userApiUrl = '$_apiHost/accounts/user_by_id/';

  // change password
  // static String changePasswordApiUrl =
  //     '$_apiHost/accounts/apis/change_password/';

  static void storeTokenUserNameAndUserId({
    required String token,
    required int userId,
    required Map<String, dynamic> user,
    required String userName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user));
    await prefs.setInt('userId', userId);
    await prefs.setString('userName', userName);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // static Future<String?> getUserId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt('userId');
  // }
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the integer value with the key 'userId'
    int? userId = prefs.getInt('userId');

    return userId; // Will return null if no value is found
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<Map<String, dynamic>?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string stored with the key 'user'
    String? userJson = prefs.getString('user');

    // Check if the JSON string exists
    if (userJson == null) {
      return null; // Return null if no user is saved
    }

    // Decode the JSON string back into a Map
    Map<String, dynamic> user = jsonDecode(userJson);

    return user; // Return the Map
  }

  static void deleteTokenUserNameAndUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('user');
    await prefs.remove('userName');
  }
}
