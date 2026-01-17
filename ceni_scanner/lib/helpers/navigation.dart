import 'package:ceni_scanner/auth/auth_provider.dart';
import 'package:ceni_scanner/auth/auth_view.dart';
import 'package:ceni_scanner/change_password/change_password_page.dart';
import 'package:ceni_scanner/kitItems/kit_items_view.dart';
import 'package:ceni_scanner/object_traking/object_provider.dart';
import 'package:ceni_scanner/object_traking/object_tracking_model.dart';
import 'package:ceni_scanner/object_traking/object_tracking_page.dart';
import 'package:ceni_scanner/position_vusialisation/position_model.dart';
import 'package:ceni_scanner/position_vusialisation/trajectoire_map.dart';
import 'package:ceni_scanner/qrcode_sccanner/qr_code_scanner.dart';
import 'package:ceni_scanner/splashScreen/splashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();
  static NavigatorState get state => key.currentState!;

  static BuildContext get context => key.currentContext!;
  

  static Future<T?> pushReplacement<T>(String route) =>
      state.pushReplacementNamed(
        route,
      );
  static pop() =>
      state.pop();

  static Future<T?> push<T>(String route, TrackedObject? argumentKey) =>
      state.pushNamed(
        route,
        arguments: {'argumentKey': argumentKey},
      );

  // static Future<T?> push<T>(BuildContext context, String route, dynamic argument) =>
  //     Navigator.of(context).pushNamed(
  //       route,
  //       arguments: {'argument': argument},
  //     );
  
 

  static Route<dynamic>? onGeneratedRoute(RouteSettings routeSettings) {
    return CupertinoPageRoute<void>(
      settings: routeSettings,
      builder: (context) {
        final route = Uri.parse(routeSettings.name!);

        switch (route.path) {
          case MyQRCodeScanner.pageRoute:
            return MyQRCodeScanner();

          // case TrajectoryPage.pageRoute:
          //   // Extract parameters from routeSettings
          //   final Map<String, dynamic>? arguments = routeSettings.arguments as Map<String, dynamic>?;
          //   if (arguments != null && arguments.containsKey('argumentKey')) {
          //     // Retrieve the trajet parameter and pass it to TrajectoryPage
          //     final List<ObjectPosition> trajet = arguments['argumentKey'] as List<ObjectPosition>;
          //     return TrajectoryPage(trajet: trajet);
          //   } else {
          //     // Handle case when trajet parameter is not provided
          //     return const SizedBox(); // or any other appropriate widget
          //   }

          case ObjectTrackingPage.pageRoute:
            return ChangeNotifierProvider(
            create: (context) => ObjectProvider(),
            child: const ObjectTrackingPage()
          );

          case LoginPage.pageRoute:
            return ChangeNotifierProvider(
            create: (context) => AuthProvider(),
            child: LoginPage()
          );

          case ChangePasswordPage.pageRoute:
            return ChangePasswordPage();

          // case MaterialElectoralForm.pageRoute:
          //   return MaterialElectoralForm();

          // case MaterialElectoralForm.pageRoute:
          //   // Extract parameters from routeSettings
          //   final Map<String, dynamic>? arguments = routeSettings.arguments as Map<String, dynamic>?;
          //   if (arguments != null && arguments.containsKey('argument')) {
          //     // Retrieve the argument and pass it to MaterialElectoralForm
          //     final String trackedObjectCode = arguments['argument'] as String;
          //     return MaterialElectoralForm(trackedObjectCode: trackedObjectCode);
          //   } else {
          //     // Handle case when argument is not provided
          //     return const SizedBox(); // or any other appropriate widget
          //   }

          case MaterialElectoralForm.pageRoute:
            // Extract parameters from routeSettings
            final Map<String, dynamic>? arguments = routeSettings.arguments as Map<String, dynamic>?;
            if (arguments != null && arguments.containsKey('argumentKey')) {
              // Retrieve the trajet parameter and pass it to TrajectoryPage
              final TrackedObject trackedObject = arguments['argumentKey'] as TrackedObject;
              return MaterialElectoralForm(trackedObject: trackedObject);
            } else {
              // Handle case when trajet parameter is not provided
              return const SizedBox(); // or any other appropriate widget
            }

          default:
            return ChangeNotifierProvider(
            create: (context) => AuthProvider(),
            child: const SplashScreen()
          );
        }
      },
    );
  }
}
