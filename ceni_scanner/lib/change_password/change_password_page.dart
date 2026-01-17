import 'package:ceni_scanner/auth/auth_provider.dart';
import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/drawer/drawer.dart';
import 'package:ceni_scanner/widgets/appButton.dart';
import 'package:ceni_scanner/widgets/password_field.dart';
import 'package:ceni_scanner/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ceni_scanner/helpers/localization.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String pageRoute = "/changePasswordPage";

  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        title: Text(ApplicationLocalization.translator.changePassword),
        actions: [
          IconButton(
              onPressed: () => authProvider.logoutUser(),
              icon: const Icon(Icons.logout)),
        ],
      ),
      drawer: MyDrawer(
        authProvider: authProvider,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 65.0, left: 20.0, right: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PasswordField(
                passwordController: _oldPasswordController,
                labelText: ApplicationLocalization.translator.oldPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ApplicationLocalization
                        .translator.pleaseEnterYourOldPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              PasswordField(
                passwordController: _newPasswordController,
                labelText: ApplicationLocalization.translator.newPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ApplicationLocalization
                        .translator.pleaseEnterANewPassword;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20.0),

              PasswordField(
                passwordController: _confirmNewPasswordController,
                labelText:
                    ApplicationLocalization.translator.confirmNewPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ApplicationLocalization
                        .translator.pleaseConfirmYourNewPassword;
                  }
                  if (value != _newPasswordController.text) {
                    return ApplicationLocalization
                        .translator.newPasswordsDoNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60.0),
              // ElevatedButton(
              //   onPressed: () => {
              //     if (_formKey.currentState!.validate()){
              //       authProvider.changeUserPassword(oldPassword: _oldPasswordController.text, newPassword: _newPasswordController.text, confirmPassword: _confirmNewPasswordController.text)
              //     }else{
              //       SnackBarHelper.showErrorSnackBar(ApplicationLocalization.translator.requiredFields)
              //     }
              //   },
              //   child: _isLoading ? const CircularProgressIndicator() : Text(ApplicationLocalization.translator.changePassword),
              // ),
              Center(
                child: AppButton(
                  text: ApplicationLocalization.translator.changePassword,
                  onPressed: () => {
                    if (_formKey.currentState!.validate())
                      {
                        authProvider.changeUserPassword(
                            oldPassword: _oldPasswordController.text,
                            newPassword: _newPasswordController.text,
                            confirmPassword: _confirmNewPasswordController.text)
                      }
                    else
                      {
                        SnackBarHelper.showErrorSnackBar(
                            ApplicationLocalization.translator.requiredFields)
                      }
                  },
                  // backgroundColor: const Color(0xFF00A95C),
                  backgroundColor: AppConstants.primaryColor,
                  textColor: Colors.white,
                  borderRadius: 5.0,
                  verticalPadding: 14.0,
                  fontSize: 14.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
