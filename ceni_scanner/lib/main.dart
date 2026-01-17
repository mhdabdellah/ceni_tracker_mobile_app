import 'package:ceni_scanner/auth/auth_provider.dart';
import 'package:ceni_scanner/helpers/navigation.dart';
import 'package:ceni_scanner/languages/language_provider.dart';
import 'package:ceni_scanner/splashScreen/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  // runApp(MyApp());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add more providers if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//   @override
  @override
  Widget build(BuildContext context) {
    // final languageProvider = context.watch<LanguageProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner :false,
      // title: ApplicationLocalization.translator.cENISCanner,
      // locale: languageProvider.locale,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const[
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.green,
          ),
      ),
      // home: const SplashScreen() ,//ObjectTrackingPage(),
      // CreateTrackedObjectForm(),
    
      navigatorKey: AppNavigator.key,
      initialRoute: SplashScreen.pageRoute,
      onGenerateRoute: AppNavigator.onGeneratedRoute,
    );
  }
}