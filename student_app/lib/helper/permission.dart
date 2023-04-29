import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

bool nearbyPerms = false;

Future<void> checkBluetoothPerms() async {
  try {
    //nearby check and request
    //scan permission check and request (required for monitoring beacons)
    PermissionStatus blScan = await Permission.bluetoothAdvertise.request();
    //connect permission (required for checking whether bluetooth in on and if not then asking the user to enable it)
    PermissionStatus nearby = await Permission.bluetoothConnect.request();
    nearbyPerms = (nearby.isGranted && blScan.isGranted) ? true : false;
    BluetoothState bluetoothState = await flutterBeacon.bluetoothState;
    if (bluetoothState == BluetoothState.stateOff) {
      await flutterBeacon.openBluetoothSettings;
    }
    PermissionStatus notification = await Permission.notification.request();
    if (notification.isGranted) {
      //print("notification granted");


    }
    await flutterBeacon.initializeScanning;
  } on PlatformException catch (e) {
    Get.snackbar("Permission Error", "Error: ${e.code}: ${e.message}");
    // library failed to initialize, check code and message
    //print("Perms Error: ${e.code}: ${e.message}");
  }
}