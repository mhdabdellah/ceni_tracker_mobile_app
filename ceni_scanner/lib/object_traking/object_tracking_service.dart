import 'dart:convert';

import 'package:ceni_scanner/auth/auth_model.dart';
import 'package:ceni_scanner/auth/auth_provider.dart';
import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/helpers/exceptions_handler.dart';
import 'package:ceni_scanner/helpers/localization.dart';
import 'package:ceni_scanner/helpers/navigation.dart';
import 'package:ceni_scanner/kitItems/kit_items_model.dart';
import 'package:ceni_scanner/kitItems/kit_items_view.dart';
import 'package:ceni_scanner/object_traking/object_tracking_model.dart';
import 'package:ceni_scanner/qrcode_sccanner/qr_code_scanner.dart';
import 'package:ceni_scanner/widgets/loader_helper.dart';
import 'package:ceni_scanner/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ObjectTrackingService {
  Future<TrackedObject> sendPosition(Map<String, dynamic> scannedObject) async {
    // Create a map containing the position data
    Map<String, dynamic> positionData = {
      'code': scannedObject['code'],
      'latitude': double.parse(scannedObject['latitude']),
      'longitude': double.parse(scannedObject['longitude']),
    };

    // Convert the position data to JSON
    String jsonBody = jsonEncode(positionData);

    LoaderHelper.showLoader();

    String? token = await AppConstants.getToken();
    // Make a POST request to send the position data
    final response = await http.post(
      Uri.parse(AppConstants.sendPositionApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );
    Map<String, dynamic> responseData = jsonDecode(response.body);

    TrackedObject trackedObject = TrackedObject.fromMap(responseData);

    return trackedObject;
  }

  Future<void> objectReceived({
    required TrackedObject trackedObject,
    KitItemsModel? kitItemsModel,
  }) async {
    // Get token from SharedPreferences
    String? token = await AppConstants.getToken();

    Map<String, dynamic> data = {
      'code': trackedObject.code,
      if (kitItemsModel != null) ...kitItemsModel.toJson()
    };
    // Make a POST request to send the position data
    final response = await http.post(
      Uri.parse(
        AppConstants.markObjectReceivedUrl,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  Future<void> sendObject({
    required TrackedObject trackedObject,
    KitItemsModel? kitItemsModel,
  }) async {
    // Get token from SharedPreferences
    String? token = await AppConstants.getToken();

    int? userId = await AppConstants().getUserId();

    if (userId == null) return;

    Map<String, dynamic> data = {
      'code': trackedObject.code,
      if (kitItemsModel != null) ...kitItemsModel.toJson()
    };
    // Make a POST request to send the position data
    final response = await http.post(
      Uri.parse(AppConstants.sendObjectApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  Future<void> detectObject({required TrackedObject trackedObject}) async {
    // Get token from SharedPreferences
    String? token = await AppConstants.getToken();

    bool detected = true;
    Map<String, dynamic> data = {
      'code': trackedObject.code,
      'detected': detected,
    };
    // Make a POST request to send the position data
    final response = await http.post(
      Uri.parse(AppConstants.detectObjectApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  Future<void> alertObject({required TrackedObject trackedObject}) async {
    // Get token from SharedPreferences
    String? token = await AppConstants.getToken();

    bool alert = true;
    Map<String, dynamic> data = {
      'code': trackedObject.code,
      'alert': alert,
    };
    // Make a POST request to send the position data
    final response = await http.post(
      Uri.parse(AppConstants.alertObjectApiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  Future<Map<String, String>> _getLocation() async {
    Map<String, String> location = {};
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      location = {
        'longitude': '${position.longitude}',
        'latitude': '${position.latitude}'
      };
    } else {
      throw LocationPermissionDeniedException(
          message: ApplicationLocalization
              .translator.locationPermissionDeniedByUser);
    }

    return location;
  }

  Future<Map<String, dynamic>> scanQRCode() async {
    String qrcodeScanRes;
    qrcodeScanRes = await AppNavigator.push(MyQRCodeScanner.pageRoute, null);
    Map<String, String> location = await _getLocation();
    Map<String, String> scannedObject = {
      "code": qrcodeScanRes,
      "latitude": location['latitude'].toString(),
      "longitude": location['longitude'].toString()
    };
    return scannedObject;
  }

  Future<Map<String, dynamic>> scanBarcode() async {
    String barcodeScanRes;
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666',
        '${ApplicationLocalization.translator.cancel}', true, ScanMode.BARCODE);

    Map<String, String> location = await _getLocation();
    Map<String, String> scannedObject = {
      "code": barcodeScanRes,
      "latitude": location['latitude'].toString(),
      "longitude": location['longitude'].toString()
    };
    return scannedObject;
  }
}
