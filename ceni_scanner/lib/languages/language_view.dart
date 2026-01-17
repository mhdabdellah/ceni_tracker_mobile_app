import 'package:ceni_scanner/helpers/localization.dart';
import 'package:ceni_scanner/languages/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return SizedBox(
          width: 200,
          child: DropdownButton<Locale>(
            value: languageProvider.locale,
            icon: const Icon(Icons.arrow_drop_down),
            // iconSize: 30, // Adjust the size of the dropdown icon if needed
            // elevation: 16,
            // style: TextStyle(color: Colors.black, fontSize: 20), // Adjust the font size here
            // underline: Container(
            //   height: 5,
            //   color: Theme.of(context).primaryColor,
            // ),
            items:  [
              DropdownMenuItem(
                value: const Locale('en'),
                child: Text(ApplicationLocalization.translator.english),
              ),
              DropdownMenuItem(
                value: const Locale('fr'),
                child: Text(ApplicationLocalization.translator.french),
              ),
              DropdownMenuItem(
                value:const Locale('ar'),
                child: Text(ApplicationLocalization.translator.arabic),
              ),
            ],
            onChanged: languageProvider.changeLanguage
            
            // (Locale? newLocale) {
            //   if (newLocale != null)  {
            //     languageProvider.changeLanguage(newLocale);
            //   }
            // },
          ),
        );
      },
    );
  }
}
