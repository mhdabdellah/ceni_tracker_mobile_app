import 'package:ceni_scanner/auth/auth_model.dart';
import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/helpers/localization.dart';
import 'package:ceni_scanner/helpers/navigation.dart';
import 'package:ceni_scanner/kitItems/kit_items_model.dart';
import 'package:ceni_scanner/kitItems/kit_items_view.dart';
import 'package:ceni_scanner/object_traking/object_tracking_model.dart';
import 'package:ceni_scanner/object_traking/object_tracking_service.dart';
import 'package:ceni_scanner/widgets/loader_helper.dart';
import 'package:ceni_scanner/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:ceni_scanner/helpers/exceptions_handler.dart';

class ObjectProvider extends ChangeNotifier {
  String _message = '';

  Map<String, dynamic> scannedObject = {};
  String get message => _message;

  bool isloading = false;
  ObjectTrackingService objectTrackingService = ObjectTrackingService();
  final ExceptionHandler _exceptionHandler = ExceptionHandler();

  UserAssignment? userAssignment;
  Map<String, dynamic>? userMap;

  ObjectProvider() {
    fechUser();
  }

  void setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  Future<void> fechUser() async {
    userMap = await AppConstants().getUser();

    notifyListeners();
  }

  void setScannedObject(Map<String, dynamic> scannedObject) {
    scannedObject = scannedObject;
    notifyListeners();
  }

  void sendPosition(Map<String, dynamic> scanneddata) async {
    LoaderHelper.showLoader();

    final response = await _exceptionHandler.exceptionCatcher<TrackedObject>(
      function: () => objectTrackingService.sendPosition(scanneddata),
    );

    LoaderHelper.hideLoader();
    if (response.result == null) return;
    TrackedObject trackedObject = response.result!;
    // userAssignment = await AuthProvider().fetchUserAssignment();
    showResponse(trackedObject: trackedObject);
    scannedObject = {};
    notifyListeners();
  }

  void objectReceived({
    required TrackedObject trackedObject,
    KitItemsModel? kitItemsModel,
  }) async {
    // notifyListeners();
    LoaderHelper.showLoader();

    final response = await _exceptionHandler.exceptionCatcher<void>(
      function: () => objectTrackingService.objectReceived(
        trackedObject: trackedObject,
        kitItemsModel: kitItemsModel,
      ),
    );

    LoaderHelper.hideLoader();
    if (response.error != null) return;
    SnackBarHelper.showSuccessSnackBar(
      ApplicationLocalization.translator.objectIsReceivedSuccessfully,
    );
  }

  // void sendObject({required TrackedObject trackedObject}) async {
  void sendObject({
    required TrackedObject trackedObject,
    KitItemsModel? kitItemsModel,
  }) async {
    LoaderHelper.showLoader();

    final response = await _exceptionHandler.exceptionCatcher<void>(
      function: () => objectTrackingService.sendObject(
        trackedObject: trackedObject,
        kitItemsModel: kitItemsModel,
      ),
    );

    LoaderHelper.hideLoader();
    if (response.error != null) return;
    SnackBarHelper.showSuccessSnackBar(
      ApplicationLocalization.translator.objectIsSendedSuccessfully,
    );
  }

  void detectObject({required TrackedObject trackedObject}) async {
    LoaderHelper.showLoader();

    final response = await _exceptionHandler.exceptionCatcher<void>(
      function: () => objectTrackingService.detectObject(
        trackedObject: trackedObject,
      ),
    );

    LoaderHelper.hideLoader();
    if (response.error != null) return;
    SnackBarHelper.showSuccessSnackBar(
      ApplicationLocalization.translator.objectIsDetectedSuccessfully,
    );
  }

  void alertObject({required TrackedObject trackedObject}) async {
    LoaderHelper.showLoader();

    final response = await _exceptionHandler.exceptionCatcher<void>(
      function: () => objectTrackingService.alertObject(
        trackedObject: trackedObject,
      ),
    );

    LoaderHelper.hideLoader();
    if (response.error != null) return;
    SnackBarHelper.showSuccessSnackBar(
      ApplicationLocalization.translator.objectIsAlertedSuccessfully,
    );
  }

  Future<void> scanBarcode() async {
    LoaderHelper.showLoader();

    final response =
        await _exceptionHandler.exceptionCatcher<Map<String, dynamic>>(
      function: () => objectTrackingService.scanBarcode(),
    );

    LoaderHelper.hideLoader();
    if (response.result == null) return;
    scannedObject = response.result!;
    notifyListeners();
    SnackBarHelper.showSuccessSnackBar("Scanned Successful");
  }

  void scanQRCode() async {
    LoaderHelper.showLoader();

    final response =
        await _exceptionHandler.exceptionCatcher<Map<String, dynamic>>(
      function: () => objectTrackingService.scanQRCode(),
    );

    LoaderHelper.hideLoader();
    if (response.result == null) return;
    scannedObject = response.result!;
    notifyListeners();
    SnackBarHelper.showSuccessSnackBar("Scanned Successful");
  }

  bool showReceivedButton({
    required TrackedObject trackedObject,
  }) {
    if (userMap == null) {
      return false;
    }

    UserModel loggedUser = UserModel.fromMap(userMap!);
    if (loggedUser.bureau == trackedObject.destination ||
        loggedUser.center == trackedObject.destination ||
        loggedUser.commune == trackedObject.destination ||
        loggedUser.moughataa == trackedObject.destination ||
        loggedUser.wilaya == trackedObject.destination) {
      return true;
    } else {
      return false;
    }
  }

  void showResponse({required TrackedObject trackedObject}) {
    // Afficher une boîte de dialogue avec l'objet suivi reçu
    showDialog(
      barrierDismissible: false,
      context: AppNavigator.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: trackedObject.status == 3
              ? Text(ApplicationLocalization.translator.materielRecu)
              : Text(ApplicationLocalization.translator.suiviDesMateriels),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text('ID: ${trackedObject.id}'),
              if (trackedObject.status == 3) ...[
                Text(
                  ApplicationLocalization
                      .translator.leMaterielEstArriveALaDestination,
                )
              ],
              Row(
                children: [
                  Text('${ApplicationLocalization.translator.code} : '),
                  Text(trackedObject.code),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Code Type : ${trackedObject.type!.codeType}',
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '${ApplicationLocalization.translator.type} : ${trackedObject.type!.name}',
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
              Row(
                children: [
                  Text('${ApplicationLocalization.translator.source} : '),
                  Text(
                    trackedObject.source,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '${ApplicationLocalization.translator.destination} : ${trackedObject.destination}',
                    overflow: TextOverflow.ellipsis,
                  )),
                  // Text(trackedObject.destination, overflow: TextOverflow.visible ),
                ],
              ),
            ],
          ),
          actions: [
            if (trackedObject.status != 3) ...[
              if (trackedObject.status != 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: showReceivedButton(trackedObject: trackedObject),
                      child: Expanded(
                        child: TextButton(
                          onPressed: () async {
                            if (trackedObject.type!.kitItems == null ||
                                trackedObject.type!.kitItems!.isEmpty) {
                              objectReceived(trackedObject: trackedObject);
                              AppNavigator.pop();
                              AppNavigator.pop();
                            } else {
                              await AppNavigator.push(
                                MaterialElectoralForm.pageRoute,
                                trackedObject,
                              );
                              AppNavigator.pop();
                            }
                            // print(
                            //     "trackedObject.type.codeType ${trackedObject.type!.codeType}");
                            // if (int.parse(trackedObject.type.codeType) != 2) {
                            //   objectReceived(trackedObject: trackedObject);
                            //   AppNavigator.pop();
                            //   AppNavigator.pop();
                            // } else {
                            //   await AppNavigator.push(
                            //       MaterialElectoralForm.pageRoute,
                            //       trackedObject);
                            //   AppNavigator.pop();
                            // }
                          },
                          child: Text(
                            ApplicationLocalization.translator.recu,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 2,
                      child: TextButton(
                        onPressed: () async {
                          detectObject(trackedObject: trackedObject);
                          AppNavigator.pop();
                          AppNavigator.pop();
                        },
                        child: Text(
                          ApplicationLocalization.translator.detected,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          !showReceivedButton(trackedObject: trackedObject),
                      child: Expanded(
                        child: TextButton(
                          onPressed: () async {
                            alertObject(trackedObject: trackedObject);
                            AppNavigator.pop();
                            AppNavigator.pop();
                          },
                          child: Text(
                            ApplicationLocalization.translator.alert,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ] else ...[
                Center(
                  child: TextButton(
                    onPressed: () async {
                      if (trackedObject.type!.kitItems == null ||
                          trackedObject.type!.kitItems!.isEmpty) {
                        sendObject(trackedObject: trackedObject);
                        AppNavigator.pop();
                        AppNavigator.pop();
                      } else {
                        await AppNavigator.push(
                          MaterialElectoralForm.pageRoute,
                          trackedObject,
                        );
                        AppNavigator.pop();
                      }
                      // if (int.parse(trackedObject.type.codeType) != 2) {
                      //   sendObject(trackedObject: trackedObject);
                      //   AppNavigator.pop();
                      //   AppNavigator.pop();
                      // } else {
                      //   await AppNavigator.push(
                      //       MaterialElectoralForm.pageRoute, trackedObject);
                      //   AppNavigator.pop();
                      // }
                    },
                    child: Text(
                      ApplicationLocalization.translator.send,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ]
            ] else
              Center(
                child: TextButton(
                  onPressed: () async {
                    AppNavigator.pop();
                  },
                  child: Text(
                    ApplicationLocalization.translator.ok,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
