import 'package:ceni_scanner/auth/auth_provider.dart';
import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/drawer/drawer.dart';
import 'package:ceni_scanner/helpers/localization.dart';
import 'package:ceni_scanner/object_traking/object_provider.dart';
import 'package:ceni_scanner/widgets/appButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObjectTrackingPage extends StatelessWidget {
  static const String pageRoute = "/object_tracking_page";
  const ObjectTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final objectProvider = context.watch<ObjectProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        actions: [
          IconButton(
              onPressed: () => authProvider.logoutUser(),
              icon: const Icon(Icons.logout)),
        ],
      ),
      drawer: MyDrawer(
        authProvider: authProvider,
      ),
      body: objectProvider.isloading
          ? Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/trans_logo.png'),
                      width: 350,
                      height: 350,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(ApplicationLocalization.translator.ceniScanner),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () => objectProvider.scanQRCode(),
                            icon: const Icon(
                              Icons.qr_code_scanner,
                              size: 60,
                              color: AppConstants.primaryColor,
                            )),
                        const SizedBox(height: 20),
                        IconButton(
                            onPressed: () => objectProvider.scanBarcode(),
                            icon: const Icon(
                              Icons.barcode_reader,
                              size: 60,
                              color: AppConstants.primaryColor,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    if (objectProvider.scannedObject.isNotEmpty) ...[
                      Consumer<ObjectProvider>(
                          builder: (context, objectProvider, _) {
                        return Column(
                          children: [
                            Text(
                                "${ApplicationLocalization.translator.code} : ${objectProvider.scannedObject['code']}"),
                            Text(
                                "${ApplicationLocalization.translator.latitude} : ${objectProvider.scannedObject['latitude']} "),
                            Text(
                                "${ApplicationLocalization.translator.longitude} : ${objectProvider.scannedObject['longitude']}  "),
                          ],
                        );
                      }),
                      const SizedBox(height: 60),
                      // ElevatedButton(
                      //   onPressed: () => objectProvider.sendPosition(objectProvider.scannedObject),
                      //   child:  Text(ApplicationLocalization.translator.getMaterialInformations),
                      // ),
                      Center(
                        child: AppButton(
                          text: ApplicationLocalization
                              .translator.getMaterialInformations,
                          onPressed: () => objectProvider
                              .sendPosition(objectProvider.scannedObject),
                          // backgroundColor: const Color(0xFF00A95C),
                          backgroundColor: AppConstants.primaryColor,
                          textColor: Colors.white,
                          borderRadius: 5.0,
                          verticalPadding: 14.0,
                          fontSize: 13.0,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 48),
                      Center(
                        child: Title(
                          color: Colors.black,
                          child: Text(
                            ApplicationLocalization.translator.pasObjectscannee,
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
    );
  }
}
