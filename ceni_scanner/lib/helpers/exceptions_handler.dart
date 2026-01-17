import 'dart:async';
import 'dart:io';
import 'package:ceni_scanner/helpers/localization.dart';
import 'package:ceni_scanner/widgets/snack_bar_helper.dart';
import 'package:flutter/services.dart';

class ExceptionHandler {
  ExceptionHandler._internal();
  static final ExceptionHandler _instance = ExceptionHandler._internal();
  factory ExceptionHandler() => _instance;

  bool _errorShown = false;

  String exceptionHandler(dynamic error) {
    String errorMessage;
    if (error is FormatException) {
      errorMessage = ApplicationLocalization.translator.formaExceptionMessage;
    } else if (error is TimeoutException) {
      errorMessage = ApplicationLocalization.translator.timeOutExceptionMessage;
    } else if (error is SocketException) {
      errorMessage = ApplicationLocalization.translator.socketExceptionMessage;
    } else if (error is HttpException) {
      errorMessage =ApplicationLocalization.translator.httpExceptionMessage;
    } else if (error is PlatformException) {
      errorMessage = _handlePlatformException(error);
    } else if (error is AuthenticationException) {
      errorMessage = ApplicationLocalization.translator.authenticationExceptionMessage;
    } else if (error is PermissionDeniedException) {
      errorMessage = ApplicationLocalization.translator.permissionDeniedExceptionMessage;
    } else {
      errorMessage = ApplicationLocalization.translator.generalExceptionMessage;
    }
    return errorMessage;
  }

  Future<ExceptionHandlerResponseModel<T>> exceptionCatcher<T>({
    required Future<T> Function() function,
    bool showSnackbar = true,
  }) async {
    try {
      return ExceptionHandlerResponseModel(result: await function.call());
    } catch (error) {
      String errorMessage = exceptionHandler(error);
      if (showSnackbar && !_errorShown) {
        _errorShown = true;
        SnackBarHelper.showErrorSnackBar(errorMessage);
        Future.delayed(Duration(seconds: 3), () {
          _errorShown = false; // Reset the flag after a delay
        });
      }
      return ExceptionHandlerResponseModel<T>(error: errorMessage);
    }
  }
}

class ExceptionHandlerResponseModel<T> {
  final String? error;
  final T? result;

  ExceptionHandlerResponseModel({this.error, this.result});
}

// Example custom exceptions
class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
}

class PermissionDeniedException implements Exception {
  final String message;
  PermissionDeniedException(this.message);
}


String _handlePlatformException(PlatformException e) {
    String errorMessage;
    switch (e.code) {
      case 'ERROR_LOCATION_SERVICE_DISABLED':
        errorMessage = ApplicationLocalization.translator.locationServiceDisabledMessage;
        break;
      case 'ERROR_LOCATION_PERMISSION_DENIED':
        errorMessage = ApplicationLocalization.translator.locationPermissionDeniedMessage;
        break;
      default:
        errorMessage = ApplicationLocalization.translator.platformExceptionMessage;
        break;
    }
    return errorMessage;
}

// Custom exception for location permission denial
class LocationPermissionDeniedException implements Exception {
  final String message;

  LocationPermissionDeniedException({required this.message});
}
