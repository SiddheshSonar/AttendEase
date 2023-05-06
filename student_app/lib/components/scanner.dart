import 'package:attendease/database/db.dart';
import 'package:attendease/views/home.dart';
import 'package:attendease/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pocketbase/pocketbase.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

List<String> dontCheck = [];
List<String> successful = [];

class _ScanQRState extends State<ScanQR> {
  final RxBool _isScanning = false.obs;
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      // formats: [BarcodeFormat.qrCode],
      autoStart: false,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    dontCheck.clear();
    successful.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        backgroundColor: Colors.blueGrey.withOpacity(0.4),
        onPressed: () {
          _isScanning.value = !_isScanning.value;
          if (_isScanning.value) {
            controller.start();
          } else {
            controller.stop();
          }
        },
        child: Obx(() {
          return Icon((_isScanning.value) ? Icons.stop : Icons.play_arrow);
        }),
      ),
      body: Center(
        child: MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (successful.contains(barcode.rawValue as String) ||
                    dontCheck.contains(barcode.rawValue as String)) {
                  Get.closeAllSnackbars();
                  Get.snackbar(
                      "Already Added Attendance", barcode.rawValue as String);
                  continue;
                }
                String encryptHash = barcode.rawValue as String;
                // print(encryptHash);
                String subject = encryptHash.split(':')[0];
                // print(encryptHash.split(':')[0]);
                bool status =
                    await updateState(encryptHash, subject, context, mounted);
                // print("updateState($teamId)");
                // final bool status =
                // await updateState(teamId).timeout(
                //   const Duration(seconds: 10),
                //   onTimeout: () {
                //     Get.closeAllSnackbars();
                //     Get.snackbar("Error", "Timeout");
                //     return false;
                //   },
                // );
                // if (status) {
                //   successful.add(teamId);
                // }
                if (status) {
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const Main();
                      }),
                      (route) => false);
                }
              }
            }),
      ),
    );
  }
}

// String userRef = "dummy_teams";
// String fuserRef = "users_col_v2";
Future<bool> updateState(
    String scanHash, String subject, BuildContext context, bool mounted) async {
  try {
    if (subject.length > 4) {
      Get.closeAllSnackbars();
      Get.snackbar("Error", "Invalid QR Code");
      return false;
    }
    RecordModel data = await PbDb.pb.collection('rohantest').getOne(
          '959gfscofc4dyw0',
        );
    // print(data);
    String encryptHash = data.data['encrypted_string'];
    // print(encryptHash);
    // print(scanHash);
    if (encryptHash == scanHash) {
      // print("Success");
      final RecordModel userData =
          await PbDb.pb.collection("students").getOne(user.id);
      //print(userData.data['attendance']);
      Map attendance = userData.data['attendance'] ?? {};
      //print(attendance);
      //print(attendance[widget.title]);
      // // add subject name to map as key, with list with datetime
      if (attendance[subject] != null) {
        List dates = attendance[subject];
        //print(dates);
        dates.add(DateTime.now().toIso8601String());
      } else {
        attendance[subject] = [DateTime.now().toIso8601String()];
      }
      //print(attendance);
      await PbDb.pb.collection('students').update(user.id, body: {
        'attendance': attendance,
      });
      successful.add(encryptHash);
      Get.closeAllSnackbars();
      Get.snackbar("Success", "Attendance Added");
      // Get.back();
      return true;
    }
  } catch (e) {
    // print(e);
    Get.closeAllSnackbars();
    Get.snackbar("Error ", "Invalid QR Code");
  }
  return false;
}
