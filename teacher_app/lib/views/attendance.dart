import 'dart:async';
import 'dart:io';

import 'package:attendease_t/database/db.dart';
// import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class Attendance extends StatefulWidget {
  const Attendance(
      {required this.title,
      required this.records,
      required this.id,
      super.key});
  final String title;
  final List<RecordModel> records;
  final String id;

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  // late List<RecordModel> studentsEnrolled ;
  late StreamSubscription beaconStream;
  List<Region> regions = <Region>[
  ];
  final RxList<int> present = <int>[].obs;
  @override
  void initState() {
    super.initState();
    fB();
  }

  @override
  void dispose() {
    flutterBeacon.close;
    beaconStream.cancel();
    super.dispose();
  }

  Future<void> fB() async {
    RecordModel data = await PbDb.pb.collection('courses').getOne(widget.id);
    // print(data.data['lectures']);
    int lectures = data.data['lectures'];
    lectures++;
    await PbDb.pb.collection('courses').update(widget.id, body: {
      'lectures': lectures,
    });
    // print(widget.records);
    if (Platform.isIOS) {
      for (int i = 0; i < widget.records.length; i++) {
        regions.add(Region(
            identifier: "spit409",
            proximityUUID:
                "00000000-0000-0000-0000-00${widget.records[i].data['uid']}",
            major: 0,
            minor: 0));
      }
    } else {
      regions.add(Region(identifier: "spit409"));
    }
  //  print(regions);
    beaconStream = flutterBeacon.ranging(regions).listen(
      (data) async {
        // print(data.beacons);
        if (data.beacons.isNotEmpty) {
          for (int i = 0; i < data.beacons.length; i++) {
            int uid = int.parse(data.beacons[i].proximityUUID.substring(26));
            if (present.contains(uid)) {
              continue;
            }
            try {
              for (int j = 0; j < widget.records.length; j++) {
                if (widget.records[j].data['uid'] == uid) {
                  final String recordId = widget.records[j].id;
                  final RecordModel userData =
                      await PbDb.pb.collection("students").getOne(recordId);
                  //print(userData.data['attendance']);
                  Map attendance = userData.data['attendance'] ?? {};
                  //print(attendance);
                  //print(attendance[widget.title]);
                  // // add subject name to map as key, with list with datetime
                  if (attendance[widget.title] != null) {
                    List dates = attendance[widget.title];
                    //print(dates);
                    dates.add(DateTime.now().toIso8601String());
                  } else {
                    attendance[widget.title] = [
                      DateTime.now().toIso8601String()
                    ];
                  }
                  //print(attendance);
                  await PbDb.pb
                      .collection('students')
                      .update(widget.records[j].id.toString(), body: {
                    'attendance': attendance,
                  });

                  present.addIf(!present.contains(uid), uid);
                  break;
                }
              }
            } catch (e) {
              // print("beacon error $e");
            }
          }
        }
      },
      // onError: (e) {
      //   print("Error $e");
      // },
      // onDone: () {
      //   print("Done");
      // },
    );
  }

  // Future<void> initPlatformState() async {
  //   if (Platform.isAndroid) {
  //     //Prominent disclosure
  //     await BeaconsPlugin.setDisclosureDialogMessage(
  //         title: "Background Locations",
  //         message:
  //             "[This app] collects location data to enable [feature], [feature], & [feature] even when the app is closed or not in use");

  //     //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
  //     //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
  //   }

  //   if (Platform.isAndroid) {
  //     BeaconsPlugin.channel.setMethodCallHandler((call) async {
  //       print("Method: ${call.method}");
  //       if (call.method == 'scannerReady') {
  //         // _showNotification("Beacons monitoring started..");
  //         await BeaconsPlugin.startMonitoring();
  //         setState(() {
  //           // isRunning = true;
  //         });
  //       } else if (call.method == 'isPermissionDialogShown') {
  //         // _showNotification(
  //         //     "Prominent disclosure message is shown to the user!");
  //       }
  //     });
  //   } else if (Platform.isIOS) {
  //     print("IOS");
  //     // _showNotification("Beacons monitoring started..");
  //     await BeaconsPlugin.startMonitoring();
  //     // setState(() {
  //     //   isRunning = true;
  //     // });
  //   }

  //   // BeaconsPlugin.listenToBeacons(beaconEventsController);

  //   await BeaconsPlugin.addRegion(
  //       "spit409", "00000000-0000-0000-0000-002021700070");

  //   // BeaconsPlugin.addBeaconLayoutForAndroid(
  //   //     "m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
  //   // BeaconsPlugin.addBeaconLayoutForAndroid(
  //   //     "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");

  //   BeaconsPlugin.setForegroundScanPeriodForAndroid(
  //       foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);

  //   BeaconsPlugin.setBackgroundScanPeriodForAndroid(
  //       backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

  //   // beaconEventsController.stream.listen(
  //   //     (data) {
  //   //       if (data.isNotEmpty) {
  //   //         // setState(() {
  //   //         //   _beaconResult = data;
  //   //         //   _results.add(_beaconResult);
  //   //         //   _nrMessagesReceived++;
  //   //         // });

  //   //         // if (!_isInForeground) {
  //   //         //   _showNotification("Beacons DataReceived: " + data);
  //   //         // }

  //   //         print("Beacons DataReceived: " + data);
  //   //       }
  //   //     },
  //   //     onDone: () {},
  //   //     onError: (error) {
  //   //       print("Error: $error");
  //   //     });

  //   //Send 'true' to run in background
  //   await BeaconsPlugin.runInBackground(true);

  //   if (!mounted) return;
  // }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date =
        " ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + date),
      ),
      body: ListView.builder(
        itemCount: widget.records.length,
        itemBuilder: (context, index) {
          // return Obx(() {
          final int uid = widget.records[index].data['uid'];
          return GestureDetector(
            onTap: () => present.addIf(!present.contains(uid), uid),
            child: ListTile(
              title: Text(widget.records[index].data['name']),
              subtitle: Text(uid.toString()),
              trailing: Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: (present.contains(uid))
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 40,
                        )
                      : const CircularProgressIndicator(
                          color: Colors.green,
                        ),
                );
              }),
            ),
          );
          // });
        },
      ),
    );
  }
}
