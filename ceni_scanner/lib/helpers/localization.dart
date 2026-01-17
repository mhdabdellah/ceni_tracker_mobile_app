import 'dart:io';

import 'package:ceni_scanner/helpers/navigation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ApplicationLocalization {
  static final translator = AppLocalizations.of(AppNavigator.context)!;

  static String getDeviceLanguage(BuildContext context) {
    return Platform.localeName.split('_')[0];
  }
}
