import 'package:ceni_scanner/auth/auth_provider.dart';
import 'package:ceni_scanner/change_password/change_password_page.dart';
import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/helpers/navigation.dart';
import 'package:ceni_scanner/object_traking/object_tracking_page.dart';
import 'package:flutter/material.dart';
import 'package:ceni_scanner/helpers/localization.dart';

class MyDrawer extends StatelessWidget {
  final String? logoPath;
  final Function? onLanguageChange;
  final AuthProvider authProvider;

  const MyDrawer({
    super.key,
    this.logoPath,
    this.onLanguageChange,
    required this.authProvider,
  });

  @override
  Widget build(BuildContext context) {
    authProvider.fetchUser();
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(
            context,
            authProvider.loggedUser != null
                ? "${authProvider.loggedUser!.firstName} ${authProvider.loggedUser!.lastName}"
                : "Guest",
          ),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                  title: ApplicationLocalization.translator.home,
                  icon: Icons.home,
                  onTap: () => AppNavigator.pushReplacement(
                      ObjectTrackingPage.pageRoute),
                ),
                _buildMenuItem(
                  title: ApplicationLocalization.translator.changePassword,
                  icon: Icons.lock,
                  onTap: () => AppNavigator.pushReplacement(
                      ChangePasswordPage.pageRoute),
                ),
                const Divider(), // Adds a separator
                _buildMenuItem(
                  title: ApplicationLocalization.translator.logout,
                  icon: Icons.exit_to_app,
                  onTap: () => authProvider.logoutUser(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, String userName) {
    return Container(
      width: double.infinity, // Ensures it fills the full width of the drawer
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(231, 217, 78, 43),
            AppConstants.primaryColor ?? Color.fromARGB(185, 75, 201, 17),
            AppConstants.primaryColor ?? Color.fromARGB(185, 75, 201, 17),
            Color.fromARGB(255, 243, 229, 38),
            AppConstants.primaryColor ?? Color.fromARGB(185, 75, 201, 17),
            AppConstants.primaryColor ?? Color.fromARGB(185, 75, 201, 17),
            Color.fromARGB(231, 217, 78, 43),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(logoPath ?? 'assets/trans_logo.png'),
            radius: 80, // Adjust size as needed
          ),
          const SizedBox(height: 16.0), // Space between logo and username
          Text(
            userName.isNotEmpty ? userName : "Guest",
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required Function? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Icon(
        icon,
        color: AppConstants.primaryColor ?? Colors.blue, // Fallback to blue
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () => onTap != null ? onTap() : {},
    );
  }
}


























// import 'package:ceni_scanner/auth/auth_provider.dart';
// import 'package:ceni_scanner/change_password/change_password_page.dart';
// import 'package:ceni_scanner/constant.dart';
// import 'package:ceni_scanner/helpers/navigation.dart';
// import 'package:ceni_scanner/languages/language_view.dart';
// import 'package:ceni_scanner/object_traking/object_tracking_page.dart';
// import 'package:flutter/material.dart';
// import 'package:ceni_scanner/helpers/localization.dart';

// class MyDrawer extends StatelessWidget {
//   final String? logoPath;
//   final Function? onLanguageChange; 
//   final AuthProvider authProvider; 

//   const MyDrawer({
//     super.key, 
//     this.logoPath,
//     this.onLanguageChange,
//    required this.authProvider
//   });

  

//   @override
//   Widget build(BuildContext context) {
//     authProvider.fetchUser();
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           _buildDrawerHeader(context,authProvider.loggedUser != null ? authProvider.loggedUser!.username : ""),
//           _buildUserInfos(context, authProvider.loggedUser != null ? authProvider.loggedUser!.username : ""),
//           _buildMenuItem(
//             title: ApplicationLocalization.translator.home,
//             icon: Icons.home,
//             onTap: () =>AppNavigator.pushReplacement(ObjectTrackingPage.pageRoute),
//           ),
//           // const Padding(
//           //   padding:  EdgeInsetsDirectional.only(start:18.0),
//           //   child:  Row(
//           //     children: [
//           //       Icon(Icons.language),
//           //       SizedBox(width: 16.0,),
//           //       LanguageSelector(),
//           //     ],
//           //   ),
//           // ),
//           _buildMenuItem(
//             title: ApplicationLocalization.translator.changePassword,
//             icon: Icons.lock,
//             onTap: () =>  AppNavigator.pushReplacement(ChangePasswordPage.pageRoute)
//           ),
//           _buildMenuItem(
//             title: ApplicationLocalization.translator.logout,
//             icon: Icons.exit_to_app,
//             onTap: () => authProvider.logoutUser()
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerHeader(BuildContext context, String userName) {
//     return UserAccountsDrawerHeader(
//       currentAccountPicture: const CircleAvatar(
//         backgroundImage: AssetImage('assets/trans_logo.png'),
//         radius: 5,
//       ),
      
//       // logoPath != null ? CircleAvatar(
//       //   backgroundImage: AssetImage(logoPath!),
//       //   radius: 5,
//       // ) :const CircleAvatar(
//       //   radius: 5,
//       // ),
//       accountName: Text(userName),
//       accountEmail: null,
//       decoration: const BoxDecoration(
//         color: AppConstants.primaryColor,
//         // color: Theme.of(context).primaryColor,
//       ),
//     );
//   }

//   Widget _buildUserInfos(BuildContext context, String userName) {
//     return ListTile(
//       title: Text(userName),
//     );
//   }

//   Widget _buildMenuItem({
//     required String title,
//     required IconData icon,
//     required Function? onTap,
//   }) {
//     return ListTile(
//       title: Text(title),
//       leading: Icon(icon),
//       onTap:() => onTap != null ? onTap() : {},
//     );
//   }
// }
