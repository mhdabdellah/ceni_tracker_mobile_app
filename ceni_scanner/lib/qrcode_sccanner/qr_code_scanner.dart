import 'package:ceni_scanner/helpers/localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class MyQRCodeScanner extends StatefulWidget {
  static const String pageRoute = "/qr_code_scanner";
  @override
  _MyQRCodeScannerState createState() => _MyQRCodeScannerState();
}

class _MyQRCodeScannerState extends State<MyQRCodeScanner> {
  Barcode? result; // Variable to store the scanned code data
  QRViewController? controller; // QRView controller

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(ApplicationLocalization.translator!.qRCodeScanner),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: GlobalKey(debugLabel: 'QR'),
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              // borderLineThickness: null,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          if (result != null)
            Container(
              color: Colors.white54,
              child: Text('${ApplicationLocalization.translator!.scannedCode} : ${result!.code}'),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop(scanData.code ?? '');
    });
    });
  }
}
