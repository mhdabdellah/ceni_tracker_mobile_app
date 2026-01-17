import 'package:ceni_scanner/auth/auth_provider.dart';
import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/helpers/localization.dart';
import 'package:ceni_scanner/widgets/appButton.dart';
import 'package:ceni_scanner/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static const String pageRoute = "/login";

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Image(
                    image: AssetImage('assets/trans_logo.png'),
                    width: 280,
                    height: 250,
                  ),
                ),
              ),
              Center(
                  child: Text(
                ApplicationLocalization.translator.login,
                style: const TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
              const SizedBox(height: 20.0),
              TextField(
                controller: authProvider.userNameController,
                decoration: InputDecoration(
                  labelText: ApplicationLocalization.translator.userName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20.0),
              PasswordField(
                passwordController: authProvider.passwordController,
                labelText: ApplicationLocalization.translator.motDePasse,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ApplicationLocalization
                        .translator.pleaseEnterANewPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40.0),
              // SizedBox(
              //   width: 600,
              //   height: 70,
              //   child: TextButton(
              //     onPressed: () => authProvider.loginUser(),
              //     child: Text(
              //       ApplicationLocalization.translator.seConnecter,
              //       style: const TextStyle(color: Colors.white),
              //     ),
              //     style: ElevatedButton.styleFrom(
              //       // primary: AppConstants.primaryColor,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //   ),
              // ),
              Center(
                child: AppButton(
                  text: ApplicationLocalization.translator.seConnecter,
                  onPressed: () => authProvider.loginUser(),
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
