import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/kitItems/kitItems_provider.dart';
import 'package:ceni_scanner/object_traking/object_provider.dart';
import 'package:ceni_scanner/object_traking/object_tracking_model.dart';
import 'package:ceni_scanner/widgets/appButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaterialElectoralForm extends StatelessWidget {
  static const String pageRoute = "/material_electoral_form";

  final TrackedObject trackedObject;

  const MaterialElectoralForm({Key? key, required this.trackedObject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MaterialElectoralFormProvider>(
          create: (_) => MaterialElectoralFormProvider(
            kitItems: trackedObject.type!.kitItems!,
          ),
        ),
        ChangeNotifierProvider<ObjectProvider>(
          create: (_) => ObjectProvider(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Kit Items Verification',
            style: TextStyle(
              fontSize: 20.0,
              // color: Colors.white, // Set text color to white
            ),
          ),
          backgroundColor: AppConstants.primaryColor,
        ),
        body: Consumer<MaterialElectoralFormProvider>(
          builder: (context, formProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Generate input fields for each kit item
                  ...trackedObject.type!.kitItems!.map((kitItem) {
                    return _buildKitItemInput(
                      context: context,
                      formProvider: formProvider,
                      kitItemName: kitItem.name,
                    );
                  }).toList(),

                  const SizedBox(height: 24.0),

                  // Submit Button
                  // Center(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       _showPreviewDialog(context, formProvider);
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 32.0,
                  //         vertical: 12.0,
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Submit',
                  //       style: TextStyle(fontSize: 16.0),
                  //     ),
                  //   ),
                  // ),
                  Center(
                    child: AppButton(
                      text: 'Submit',
                      onPressed: () {
                        _showPreviewDialog(context, formProvider);
                      },
                      // backgroundColor: const Color(0xFF00A95C),
                      backgroundColor: AppConstants.primaryColor,
                      textColor: Colors.white,
                      borderRadius: 5.0,
                      verticalPadding: 12.0,
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKitItemInput({
    required BuildContext context,
    required MaterialElectoralFormProvider formProvider,
    required String kitItemName,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kitItemName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            initialValue:
                formProvider.formData.quantities[kitItemName]?.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter quantity for $kitItemName',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
            onChanged: (value) {
              final quantity = int.tryParse(value) ?? 0;
              formProvider.updateItemQuantity(kitItemName, quantity);
            },
          ),
        ],
      ),
    );
  }

  void _showPreviewDialog(
    BuildContext context,
    MaterialElectoralFormProvider formProvider,
  ) {
    final objectProvider = Provider.of<ObjectProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: trackedObject.type!.kitItems!.map((kitItem) {
                return Text(
                  '${kitItem.name}: ${formProvider.formData.quantities[kitItem.name] ?? 0}',
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                // -1 => alert | 0 => generated | 1 => sended | 2 => detected | 3 => received
                trackedObject.status == 0
                    ? objectProvider.sendObject(
                        trackedObject: trackedObject,
                        kitItemsModel: formProvider.formData,
                      )
                    : objectProvider.objectReceived(
                        trackedObject: trackedObject,
                        kitItemsModel: formProvider.formData,
                      );
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}













// import 'package:ceni_scanner/auth/auth_provider.dart';


// import 'package:ceni_scanner/constant.dart';
// import 'package:ceni_scanner/drawer/drawer.dart';
// import 'package:ceni_scanner/helpers/localization.dart';
// import 'package:ceni_scanner/helpers/navigation.dart';
// import 'package:ceni_scanner/kitItems/kit_items_model.dart';
// import 'package:ceni_scanner/object_traking/object_tracking_model.dart';
// import 'package:ceni_scanner/widgets/is_completed.dart';
// import 'package:ceni_scanner/widgets/snack_bar_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:provider/provider.dart';

// class MaterialElectoralForm extends StatefulWidget {
//   static const String pageRoute = "/material_electoral_form";

//   final TrackedObject trackedObject;
//   const MaterialElectoralForm({super.key, required this.trackedObject});

//   @override
//   _MaterialElectoralFormState createState() => _MaterialElectoralFormState();
// }

// class _MaterialElectoralFormState extends State<MaterialElectoralForm> {
//   final _formData = KitItemsModel();
//   int _currentStep = 0;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize quantities and checkboxes
//     for (var kitItem in widget.trackedObject.type!.kitItems!) {
//       _formData.quantities[kitItem.name] = kitItem.quantity ?? 0;
//       _formData.isChecked[kitItem.name] = true;
//     }
//   }

//   List<Step> _buildSteps() {
//     return widget.trackedObject.type!.kitItems!.map((kitItem) {
//       return Step(
//         title: Text('${kitItem.name} (${kitItem.quantity})'),
//         content: Row(
//           children: [
//             Checkbox(
//               value: _formData.isChecked[kitItem.name] ?? true,
//               onChanged: (newValue) {
//                 setState(() {
//                   bool isChecked = newValue ?? true;
//                   _formData.toggleChecked(kitItem.name, isChecked);
//                   // Reset quantity based on checkbox
//                   _formData.updateQuantity(
//                     kitItem.name,
//                     isChecked ? kitItem.quantity ?? 0 : 0,
//                   );
//                 });
//               },
//             ),
//             Expanded(
//               child: TextFormField(
//                 initialValue: _formData.quantities[kitItem.name]?.toString(),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     int quantity = int.tryParse(value) ?? 0;
//                     _formData.updateQuantity(kitItem.name, quantity);
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }

//   void _showPreviewDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Details'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: widget.trackedObject.type!.kitItems!.map((kitItem) {
//                 return Text(
//                   '${kitItem.name}: ${_formData.quantities[kitItem.name] ?? 0}',
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Confirm'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _submitForm();
//               },
//             ),
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _submitForm() async {
//     // Simulate form submission
//     print("Form Data: ${_formData.toJson()}");
//     // Add your API call logic here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Kit Items Management'),
//       ),
//       body: Stepper(
//         currentStep: _currentStep,
//         onStepContinue: () {
//           if (_currentStep < _buildSteps().length - 1) {
//             setState(() {
//               _currentStep += 1;
//             });
//           } else {
//             _showPreviewDialog(context);
//           }
//         },
//         onStepCancel: () {
//           if (_currentStep > 0) {
//             setState(() {
//               _currentStep -= 1;
//             });
//           }
//         },
//         steps: _buildSteps(),
//       ),
//     );
//   }
// }

// // class MaterialElectoralForm extends StatefulWidget {
// //   static const String pageRoute = "/material_electoral_form";
// //   final TrackedObject trackedObject;
// //   const MaterialElectoralForm({super.key, required this.trackedObject});

// //   @override
// //   _MaterialElectoralFormState createState() => _MaterialElectoralFormState();
// // }

// // class _MaterialElectoralFormState extends State<MaterialElectoralForm> {
// //   final _formData = KitItemsModel();

// //   int _currentStep = 0;

// //   void _submitForm() async {
// //     showDialog(
// //       context: AppNavigator.context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return const Center(
// //           child: CircularProgressIndicator(),
// //         );
// //       },
// //     );

// //     print("Kit Electoral : ${_formData.toJson()}");

// //     try {
// //       int? userId = await AppConstants().getUserId();

// //       Map<String, dynamic> data = {
// //         'code': widget.trackedObject.code,
// //         'user_id': userId!,
// //         ..._formData.toJson()
// //       };

// //       print("data : ${data}");

// //       // -1 => alert | 0 => generated | 1 => sended | 2 => detected | 3 => received
// //       http.Response response = await http.post(
// //         Uri.parse(
// //           widget.trackedObject.status == 0
// //               ? AppConstants.sendObjectApiUrl
// //               : AppConstants.markObjectReceivedUrl,
// //         ),
// //         headers: <String, String>{
// //           'Content-Type': 'application/json; charset=UTF-8',
// //         },
// //         body: jsonEncode(data),
// //       );

// //       // print("apiLog ***** the api is : ${ widget.trackedObject.status == 0 ? AppConstants.sendObjectApiUrl : AppConstants.markObjectReceivedUrl}");

// //       AppNavigator.pop();

// //       if (response.statusCode == 200) {
// //         // ScaffoldMessenger.of(AppNavigator.context).showSnackBar(SnackBar(
// //         //   content: const Text('Object is received successfully'),
// //         //   backgroundColor: Colors.green,
// //         // ));
// //         widget.trackedObject.status == 0
// //             ? SnackBarHelper.showSuccessSnackBar(
// //                 ApplicationLocalization.translator.objectIsSendedSuccessfully)
// //             : SnackBarHelper.showSuccessSnackBar(ApplicationLocalization
// //                 .translator.objectIsReceivedSuccessfully);

// //         AppNavigator.pop();
// //         AppNavigator.pop();
// //       } else {
// //         print('Failed : ${response.body}: ${response.statusCode}');
// //         // ScaffoldMessenger.of(AppNavigator.context).showSnackBar(SnackBar(
// //         //   content: Text('Failed : ${response.body} : ${response.statusCode}'),
// //         //   backgroundColor: Colors.red,
// //         // ));
// //         SnackBarHelper.showErrorSnackBar(
// //             '${ApplicationLocalization.translator.failed} : ${ApplicationLocalization.translator.isNotComplete}');
// //       }
// //     } catch (error) {
// //       print('Network error: $error');
// //       AppNavigator.pop();
// //       // ScaffoldMessenger.of(AppNavigator.context).showSnackBar(SnackBar(
// //       //   content: Text('Network error: $error'),
// //       //   backgroundColor: Colors.red,
// //       // ));
// //       SnackBarHelper.showErrorSnackBar(
// //           ApplicationLocalization.translator.networkError);
// //     }
// //   }

// //   Widget _buildNumberField({
// //     required int? numberValue,
// //     required ValueChanged<String> onNumberChanged,
// //   }) {
// //     return Row(
// //       children: [
// //         Text(ApplicationLocalization.translator.quantity),
// //         const SizedBox(width: 10),
// //         Expanded(
// //           child: TextFormField(
// //             initialValue: numberValue?.toString() ?? '',
// //             keyboardType: TextInputType.number,
// //             onChanged: onNumberChanged,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   List<Step> _buildSteps() {
// //     return [
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.batterie} (06)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: _formData.batterie,
// //                 numberValue: 6,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.batterieNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.batterie =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.batterieNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.batterieNumber = int.tryParse(value);
// //                     _formData.batterie = _formData.batterieNumber != null &&
// //                         _formData.batterieNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.tubeEncre} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.tubeEncreNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.tubeEncre =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.tubeEncreNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.tubeEncreNumber = int.tryParse(value);
// //                     _formData.tubeEncre = _formData.tubeEncreNumber != null &&
// //                         _formData.tubeEncreNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text(
// //             '${ApplicationLocalization.translator.enveloppesGrandModele} (10)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 10,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.largeEnvelopesNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.largeEnvelopes =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.largeEnvelopesNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.largeEnvelopesNumber = int.tryParse(value);
// //                     _formData.largeEnvelopes =
// //                         _formData.largeEnvelopesNumber != null &&
// //                             _formData.largeEnvelopesNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       // Step(
// //       //   title: Text('${ApplicationLocalization.translator.recueilDesTextesRelatifsAuxElections} (01)'),
// //       //   content:widget.trackedObject.status == 0
// //       //   ? IsCompletedWidget(
// //       //       isComplete: false,
// //       //       numberValue: 1,
// //       //       onNumberChanged: ( newValue) {
// //       //           setState(() {
// //       //             _formData.electionTextsCompendiumNumber = newValue;

// //       //           });
// //       //         },
// //       //       onChanged: (newStatus){
// //       //         _formData.electionTextsCompendium = newStatus ?? false; // Update the completion status
// //       //       },
// //       //     )
// //       //   : _buildNumberField(
// //       //     numberValue: _formData.electionTextsCompendiumNumber,
// //       //     onNumberChanged: (value) {
// //       //       setState(() {
// //       //         _formData.electionTextsCompendiumNumber = int.tryParse(value);
// //       //         _formData.electionTextsCompendium = _formData.electionTextsCompendiumNumber != null && _formData.electionTextsCompendiumNumber! > 0;
// //       //       });
// //       //     },
// //       //   ),
// //       // ),
// //       // Step(
// //       //   title: Text('${ApplicationLocalization.translator.guideDesOperationsDeVote} (01)'),
// //       //   content:widget.trackedObject.status == 0
// //       //   ? IsCompletedWidget(
// //       //       isComplete: false,
// //       //       numberValue: 1,
// //       //       onNumberChanged: ( newValue) {
// //       //           setState(() {
// //       //             _formData.votingOperationsGuideNumber = newValue;

// //       //           });
// //       //         },
// //       //       onChanged: (newStatus){
// //       //         _formData.votingOperationsGuide = newStatus ?? false; // Update the completion status
// //       //       },
// //       //     )
// //       //   : _buildNumberField(
// //       //     numberValue: _formData.votingOperationsGuideNumber,
// //       //     onNumberChanged: (value) {
// //       //       setState(() {
// //       //         _formData.votingOperationsGuideNumber = int.tryParse(value);
// //       //         _formData.votingOperationsGuide = _formData.votingOperationsGuideNumber != null && _formData.votingOperationsGuideNumber! > 0;
// //       //       });
// //       //     },
// //       //   ),
// //       // ),
// //       Step(
// //         title: Text(
// //             '${ApplicationLocalization.translator.mementoDesProceduresApplicablesALelectionPresidentielle} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.presidentialElectionProceduresMemoNumber =
// //                         newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.presidentialElectionProceduresMemo =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.presidentialElectionProceduresMemoNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.presidentialElectionProceduresMemoNumber =
// //                         int.tryParse(value);
// //                     _formData.presidentialElectionProceduresMemo = _formData
// //                                 .presidentialElectionProceduresMemoNumber !=
// //                             null &&
// //                         _formData.presidentialElectionProceduresMemoNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.scelles} (07)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 7,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.sealsNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.seals =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.sealsNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.sealsNumber = int.tryParse(value);
// //                     _formData.seals = _formData.sealsNumber != null &&
// //                         _formData.sealsNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text(
// //             '${ApplicationLocalization.translator.flaconsDencreIndelebile} (02)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 2,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.indelibleInkBottlesNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.indelibleInkBottles =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.indelibleInkBottlesNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.indelibleInkBottlesNumber = int.tryParse(value);
// //                     _formData.indelibleInkBottles =
// //                         _formData.indelibleInkBottlesNumber != null &&
// //                             _formData.indelibleInkBottlesNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title:
// //             Text('${ApplicationLocalization.translator.lampesDeclairage} (02)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 2,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.flashlightsNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.flashlights =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.flashlightsNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.flashlightsNumber = int.tryParse(value);
// //                     _formData.flashlights =
// //                         _formData.flashlightsNumber != null &&
// //                             _formData.flashlightsNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.isoloirs} (02)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 2,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.votingBoothsNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.votingBooths =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.votingBoothsNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.votingBoothsNumber = int.tryParse(value);
// //                     _formData.votingBooths =
// //                         _formData.votingBoothsNumber != null &&
// //                             _formData.votingBoothsNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.cachetAVote} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 // onNumberChanged: (int value) {
// //                 //   setState(() {
// //                 //     _formData.votedStampNumber = value;
// //                 //     _formData.votedStamp = _formData.votedStampNumber != null && _formData.votedStampNumber! > 0;

// //                 //   });
// //                 // },
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.votedStampNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.votedStamp =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.votedStampNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.votedStampNumber = int.tryParse(value);
// //                     _formData.votedStamp = _formData.votedStampNumber != null &&
// //                         _formData.votedStampNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.encreur} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.inkwellNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.inkwell =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.inkwellNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.inkwellNumber = int.tryParse(value);
// //                     _formData.inkwell = _formData.inkwellNumber != null &&
// //                         _formData.inkwellNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.calculatrice} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.calculatorNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.calculator =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.calculatorNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.calculatorNumber = int.tryParse(value);
// //                     _formData.calculator = _formData.calculatorNumber != null &&
// //                         _formData.calculatorNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.ciseaux} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.scissorsNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.scissors =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.scissorsNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.scissorsNumber = int.tryParse(value);
// //                     _formData.scissors = _formData.scissorsNumber != null &&
// //                         _formData.scissorsNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.stylos} (03)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 3,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.pensNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.pens =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.pensNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.pensNumber = int.tryParse(value);
// //                     _formData.pens = _formData.pensNumber != null &&
// //                         _formData.pensNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.scotch} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.scotchTapeNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.scotchTape =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.scotchTapeNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.scotchTapeNumber = int.tryParse(value);
// //                     _formData.scotchTape = _formData.scotchTapeNumber != null &&
// //                         _formData.scotchTapeNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.regleGraduee} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.rulerNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.ruler =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.rulerNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.rulerNumber = int.tryParse(value);
// //                     _formData.ruler = _formData.rulerNumber != null &&
// //                         _formData.rulerNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title: Text('${ApplicationLocalization.translator.gilets} (03)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 3,
// //                 // onNumberChanged: (int value) {
// //                 //   setState(() {
// //                 //     _formData.vestsNumber = value;
// //                 //     _formData.vests = _formData.vestsNumber != null && _formData.vestsNumber! > 0;

// //                 //   });
// //                 // },
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.vestsNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.vests =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.vestsNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.vestsNumber = int.tryParse(value);
// //                     _formData.vests = _formData.vestsNumber != null &&
// //                         _formData.vestsNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       // Step(
// //       //   title: Text('${ApplicationLocalization.translator.badges} (03)'),
// //       //   content:widget.trackedObject.status == 0
// //       //   ? IsCompletedWidget(
// //       //       isComplete: false,
// //       //       numberValue: 3,
// //       //       onNumberChanged: ( newValue) {
// //       //           setState(() {
// //       //             _formData.badgesNumber = newValue;

// //       //           });
// //       //         },
// //       //       onChanged: (newStatus){
// //       //         _formData.badges = newStatus ?? false; // Update the completion status
// //       //       },
// //       //     )
// //       //   : _buildNumberField(
// //       //     numberValue: _formData.badgesNumber,
// //       //     onNumberChanged: (value) {
// //       //       setState(() {
// //       //         _formData.badgesNumber = int.tryParse(value);
// //       //         _formData.badges = _formData.badgesNumber != null && _formData.badgesNumber! > 0;
// //       //       });
// //       //     },
// //       //   ),
// //       // ),
// //       Step(
// //         title:
// //             Text('${ApplicationLocalization.translator.sacGrandFormat} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.largeBagNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.largeBag =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.largeBagNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.largeBagNumber = int.tryParse(value);
// //                     _formData.largeBag = _formData.largeBagNumber != null &&
// //                         _formData.largeBagNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),
// //       Step(
// //         title:
// //             Text('${ApplicationLocalization.translator.autocollantUrne} (01)'),
// //         content: widget.trackedObject.status == 0
// //             ? IsCompletedWidget(
// //                 isComplete: false,
// //                 numberValue: 1,
// //                 onNumberChanged: (newValue) {
// //                   setState(() {
// //                     _formData.ballotBoxStickerNumber = newValue;
// //                   });
// //                 },
// //                 onChanged: (newStatus) {
// //                   _formData.ballotBoxSticker =
// //                       newStatus ?? false; // Update the completion status
// //                 },
// //               )
// //             : _buildNumberField(
// //                 numberValue: _formData.ballotBoxStickerNumber,
// //                 onNumberChanged: (value) {
// //                   setState(() {
// //                     _formData.ballotBoxStickerNumber = int.tryParse(value);
// //                     _formData.ballotBoxSticker =
// //                         _formData.ballotBoxStickerNumber != null &&
// //                             _formData.ballotBoxStickerNumber! > 0;
// //                   });
// //                 },
// //               ),
// //       ),

// //       // Step(
// //       //   title:  Text('${ApplicationLocalization.translator.banderole} (01)'),
// //       //   content: widget.trackedObject.status == 0
// //       //   ? IsCompletedWidget(
// //       //       isComplete: false,
// //       //       numberValue: 1,
// //       //       onNumberChanged: ( newValue) {
// //       //           setState(() {
// //       //             _formData.bannerNumber = newValue;

// //       //           });
// //       //         },
// //       //       onChanged: (newStatus){
// //       //          setState(() {
// //       //             _formData.banner = newStatus ?? false; // Update the completion status
// //       //             if(_formData.banner){
// //       //               _formData.bannerNumber = 1;
// //       //             }else{
// //       //               _formData.bannerNumber = 0;
// //       //             }

// //       //           });
// //       //       },
// //       //     )
// //       //   :_buildNumberField(
// //       //     numberValue: _formData.bannerNumber,
// //       //     onNumberChanged: (value) {
// //       //       setState(() {
// //       //         _formData.bannerNumber = int.tryParse(value);
// //       //         _formData.banner = _formData.bannerNumber != null && _formData.bannerNumber! > 0;
// //       //       });
// //       //     },
// //       //   ),
// //       // ),
// //     ];
// //   }

// //   void _showPreviewDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text(ApplicationLocalization.translator.confirmDetails),
// //           content: SingleChildScrollView(
// //             child: ListBody(children: <Widget>[
// //               Text(
// //                   '${ApplicationLocalization.translator.batterie} (06): ${_formData.batterieNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.tubeEncre} (01): ${_formData.tubeEncreNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.enveloppesGrandModele} (10): ${_formData.largeEnvelopesNumber ?? 0}'),
// //               // Text('${ApplicationLocalization.translator.recueilDesTextesRelatifsAuxElections} (01): ${_formData.electionTextsCompendiumNumber ?? 0}'),
// //               // Text('${ApplicationLocalization.translator.guideDesOperationsDeVote} (01): ${_formData.votingOperationsGuideNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.mementoDesProceduresApplicablesALelectionPresidentielle} (01): ${_formData.presidentialElectionProceduresMemoNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.scelles} (07): ${_formData.sealsNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.flaconsDencreIndelebile} (02): ${_formData.indelibleInkBottlesNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.lampesDeclairage} (02): ${_formData.flashlightsNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.isoloirs} (02): ${_formData.votingBoothsNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.cachetAVote} (01): ${_formData.votedStampNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.encreur} (01): ${_formData.inkwellNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.calculatrice} (01): ${_formData.calculatorNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.ciseaux} (01): ${_formData.scissorsNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.stylos} (03): ${_formData.pensNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.scotch} (01): ${_formData.scotchTapeNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.regleGraduee} (01): ${_formData.rulerNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.gilets} (03): ${_formData.vestsNumber ?? 0}'),
// //               // Text('${ApplicationLocalization.translator.badges} (03): ${_formData.badgesNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.sacGrandFormat} (01): ${_formData.largeBagNumber ?? 0}'),
// //               Text(
// //                   '${ApplicationLocalization.translator.autocollantUrne} (01): ${_formData.ballotBoxStickerNumber ?? 0}'),
// //               // Text('${ApplicationLocalization.translator.banderole} (01): ${_formData.bannerNumber ?? 0}'),
// //             ]),
// //           ),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text(ApplicationLocalization.translator.confirm),
// //               onPressed: () {
// //                 AppNavigator.pop();
// //                 _submitForm();
// //               },
// //             ),
// //             TextButton(
// //               child: Text(ApplicationLocalization.translator.cancel),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final authProvider = context.watch<AuthProvider>();
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: AppConstants.primaryColor,
// //         title: Text(ApplicationLocalization.translator.materialReceived),
// //         actions: [
// //           IconButton(
// //             onPressed: () {
// //               AppNavigator.pop();
// //               AppNavigator.pop();
// //             },
// //             icon: const Icon(Icons.home),
// //           )
// //         ],
// //       ),
// //       drawer: MyDrawer(
// //         authProvider: authProvider,
// //       ),
// //       body: Stepper(
// //         currentStep: _currentStep,
// //         onStepContinue: () {
// //           if (_currentStep < _buildSteps().length - 1) {
// //             setState(() {
// //               _currentStep += 1;
// //             });
// //           } else {
// //             _showPreviewDialog(context);
// //           }
// //         },
// //         onStepCancel: () {
// //           if (_currentStep > 0) {
// //             setState(() {
// //               _currentStep -= 1;
// //             });
// //           }
// //         },
// //         steps: _buildSteps(),
// //       ),
// //     );
// //   }
// // }
