// import 'package:ceni_scanner/main.dart';
import 'dart:io';

import 'package:ceni_scanner/helpers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LanguageProvider extends ChangeNotifier {

  late Locale _locale;
  Locale get locale => _locale;

  List<Locale> get supportedLocales {
    return [locale];
  }

  

  LanguageProvider() {
    _locale = Locale(Platform.localeName.split('_')[0]);
  }


  void changeLanguage(Locale? newLocaleCode) async{
    print("newLocaleCode : ${newLocaleCode}");
    if(newLocaleCode == null) return;
    _locale = Locale(newLocaleCode.languageCode,'');
    notifyListeners();
    await saveLocaleToStorage(newLocaleCode);
  }

  Future<Locale?> loadLocaleFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return null;
  }

  Future<void> saveLocaleToStorage(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }
}