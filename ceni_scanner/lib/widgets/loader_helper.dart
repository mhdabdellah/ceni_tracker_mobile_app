
import 'package:ceni_scanner/helpers/navigation.dart';
import 'package:flutter/material.dart';

class LoaderHelper{
  
  static showLoader() {
    // Show loader
    final loader = showDialog(
      context: AppNavigator.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
  );
    return loader;
  }

  static hideLoader(){
    return Navigator.of(AppNavigator.context).pop();
  }
}