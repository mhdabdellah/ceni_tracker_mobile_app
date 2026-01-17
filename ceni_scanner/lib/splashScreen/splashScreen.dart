import 'dart:async';
import 'package:ceni_scanner/auth/auth_provider.dart';
import 'package:ceni_scanner/auth/auth_view.dart';
import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/helpers/localization.dart';
import 'package:ceni_scanner/helpers/navigation.dart';
import 'package:ceni_scanner/object_traking/object_tracking_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:minister_exterieure_mobile_app/views/userinfo_in_setps.dart';

class SplashScreen extends StatefulWidget {

  static const String pageRoute = "/";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch the user from AuthProvider
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // authProvider.fetchUser();

    Timer(const Duration(seconds: 3), () async {

      // Get token from SharedPreferences
      String? token = await AppConstants.getToken();
      
      if (token == null) {
        AppNavigator.pushReplacement(LoginPage.pageRoute);
      }else{
        AppNavigator.pushReplacement(ObjectTrackingPage.pageRoute);
      }
      // AppNavigator.pushReplacement(ObjectTrackingPage.pageRoute);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  Container(
            margin:  const EdgeInsets.only(bottom: 20.0, top: 200.0),
            child:  Column(
              children: [
                const Image(
                  image: AssetImage('assets/trans_logo.png'),
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 30.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text(
                      ApplicationLocalization.translator.cENISCanner,
                      style: const TextStyle(
                          fontSize:
                              25.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 120,),
                      child: Row(
                        children: [
                          Text(
                            "${ApplicationLocalization.translator.version} : ",
                            style: const TextStyle(
                                fontSize:
                                    18.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            " 2.0.5",
                            style: TextStyle(
                                fontSize:
                                    18.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                      
                        ],
                      ),
                    ),
              
                  ],
                )
              ],
            ),
          ),
      ),
    );
  }
}
