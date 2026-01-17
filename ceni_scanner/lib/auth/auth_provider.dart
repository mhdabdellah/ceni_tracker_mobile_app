import 'package:ceni_scanner/auth/auth_model.dart';
import 'package:ceni_scanner/auth/auth_serice.dart';
import 'package:ceni_scanner/auth/auth_view.dart';
import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/helpers/exceptions_handler.dart';
import 'package:ceni_scanner/helpers/localization.dart';
import 'package:ceni_scanner/helpers/navigation.dart';
import 'package:ceni_scanner/splashScreen/splashScreen.dart';
import 'package:ceni_scanner/widgets/loader_helper.dart';
import 'package:ceni_scanner/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final ExceptionHandler _exceptionHandler = ExceptionHandler();

  AuthService authService = AuthService();
  UserAssignment? userAssignment;
  UserModel? loggedUser;

  // AuthProvider() {
  //   fetchUser();
  // }

  Future<String?> get loggedUserName async {
    String? nm = await AppConstants.getUserName();
    return nm;
  }

  void loginUser() async {
    LoaderHelper.showLoader();
    final userName = userNameController.text.trim();
    final password = passwordController.text.trim();

    final response =
        await _exceptionHandler.exceptionCatcher<Map<String, dynamic>>(
      function: () => authService.login(userName, password),
    );

    LoaderHelper.hideLoader();
    if (response.result == null) return;

    String accessToken = response.result!['access_token'];
    // String userId = response.result!['user'].id;
    // dynamic user = response.result!['user'];
    UserModel user = UserModel.fromMap(response.result!['user']);
    AppConstants.storeTokenUserNameAndUserId(
      token: accessToken,
      user: user.toMap(),
      userId: user.id,
      userName: userName,
    );
    AppNavigator.pushReplacement(SplashScreen.pageRoute);
    SnackBarHelper.showSuccessSnackBar(
      ApplicationLocalization.translator.loggedSuccessfully,
    );
  }

  void logoutUser() async {
    LoaderHelper.showLoader();

    final response =
        await _exceptionHandler.exceptionCatcher<Map<String, dynamic>>(
      function: () => authService.logout(),
    );

    LoaderHelper.hideLoader();
    if (response.result == null) return;

    AppConstants.deleteTokenUserNameAndUserId();
    AppNavigator.pushReplacement(LoginPage.pageRoute);
    SnackBarHelper.showSuccessSnackBar(
        ApplicationLocalization.translator.logoutSuccessful);
  }

  void changeUserPassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    showDialog(
      context: AppNavigator.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    int? userId = await AppConstants().getUserId();
    String? token = await AppConstants.getToken();
    if (userId == null && token == null) {
      AppNavigator.pop();
      return;
    }

    final response =
        await _exceptionHandler.exceptionCatcher<Map<String, dynamic>>(
      function: () => authService.changePassword(
        oldPassword,
        newPassword,
        confirmPassword,
        userId!,
        token!,
      ),
      showSnackbar: false,
    );

    AppNavigator.pop();

    if (response.result != null && response.result!.containsKey('message')) {
      SnackBarHelper.showSuccessSnackBar(
          ApplicationLocalization.translator.passwordChangedSuccessfully);
      logoutUser();
    } else if (response.result != null &&
        response.result!.containsKey('error')) {
      final error = response.result!['error'];
      if (error == 'Incorrect old password') {
        SnackBarHelper.showErrorSnackBar(
            ApplicationLocalization.translator.incorrectOldPassword);
      } else if (error == 'New passwords do not match') {
        SnackBarHelper.showErrorSnackBar(
            ApplicationLocalization.translator.newPasswordsDoNotMatch);
      } else {
        SnackBarHelper.showErrorSnackBar(
            ApplicationLocalization.translator.errorInPasswordChange);
      }
    } else if (response.error != null) {
      SnackBarHelper.showErrorSnackBar(response.error!);
    }
  }

  Future<UserAssignment?> fetchUserAssignment() async {
    LoaderHelper.showLoader();

    int? userId = await AppConstants().getUserId();
    if (userId == null) {
      LoaderHelper.hideLoader();
      return null;
    }

    final response = await _exceptionHandler.exceptionCatcher<UserAssignment>(
      function: () => authService.getUserAssignment(userId),
    );

    LoaderHelper.hideLoader();
    if (response.result != null) {
      userAssignment = response.result;
    }
    notifyListeners();
    return userAssignment;
  }

  void fetchUser() async {
    // int? user = await AppConstants().getUser();
    Map<String, dynamic>? userMap = await AppConstants().getUser();

    if (userMap == null) {
      return;
    }

    loggedUser = UserModel.fromMap(userMap);
    notifyListeners();
  }
  // void fetchUser() async {
  //   int? userId = await AppConstants().getUserId();
  //   if (userId == null) {
  //     return;
  //   }

  //   final response = await _exceptionHandler.exceptionCatcher<User>(
  //     function: () => authService.getUser(userId),
  //   );

  //   if (response.result != null) {
  //     loggedUser = response.result;
  //   }
  //   notifyListeners();
  // }
}
