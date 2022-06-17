import 'dart:math';

import 'package:fall_detection_v2/Utils/constants.dart';
import 'package:fall_detection_v2/Utils/disposable_widget.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TestingSensor extends StatefulWidget {
  @override
  _TestingSensorState createState() => _TestingSensorState();
}

class _TestingSensorState extends State<TestingSensor> with DisposableWidget {
  // var textButtonStop = 'Stop Service';
  // var textButtonStart = 'Resume Service';
  // var isStopDisabled = false;
  // var isResumeDisabled = true;
  String status = "Status";
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();

    accelerometerEvents
        .listen((event) => print("LISTENING BABYY"))
        .canceledBy(this);
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void dispose() {
    cancelSubscription();
    super.dispose();
  }

  @override
  Widget build(_) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Testing Sensor',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Text("Status: $status"),
              // StreamBuilder<AccelerometerEvent>(
              //   stream: accelerometerEvents,
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //
              //     final data = snapshot.data;
              //     final x = data?.x ?? 0;
              //     final y = data?.y ?? 0;
              //     final z = data?.z ?? 0;
              //     final gx = x / 9.80665;
              //     final gy = y / 9.80665;
              //     final gz = z / 9.80665;
              //     final gForce = sqrt(pow(gx, 2) + pow(gy, 2) + pow(gz, 2));
              //     const gravityThreshold = 2.7;
              //
              //     if (gForce > gravityThreshold) {
              //       final now = DateTime.now().millisecondsSinceEpoch;
              //       const delay = 1000;
              //
              //       if (timestamp + delay < now) {
              //         // setState(() {
              //         //   status = "JATOHHHH";
              //         // });
              //         WidgetsBinding.instance?.addPostFrameCallback(
              //           (_) {
              //             // ScaffoldMessenger.of(context).clearSnackBars();
              //             // ScaffoldMessenger.of(context).showSnackBar(
              //             //   const SnackBar(content: Text("LUGURRRRRR")),
              //             // );
              //             showSimpleNotification(
              //               Text('Anda terjatuh!!', style:TextStyle(fontSize: 16)),
              //               subtitle: Text('Segera teriak cari pertolongan!'),
              //               background: Colors.black,
              //               duration: Duration(seconds: 30),
              //             );
              //            _makePhoneCall('083162937284');
              //           },
              //         );
              //       }
              //     }
              //
              //     return Text(
              //       "Accelerometer value\n$gx\n$gy\n$gz",
              //     );
              //   },
              // )
              // // Container(
              // //     margin: EdgeInsets.only(bottom: 10),
              // //     child: Wrap(
              // //       spacing: 10,
              // //       children: [
              // //         ElevatedButton.icon(
              // //             icon: Icon(Icons.stop),
              // //             label: Text("Stop"),
              // //             onPressed: () async {
              // //               var isRunning = await FlutterBackgroundService()
              // //                   .isServiceRunning();
              // //               if (isStopDisabled) {
              // //                 null;
              // //               } else {
              // //                 if (isRunning) {
              // //                   FlutterBackgroundService().sendData(
              // //                     {"action": "stopService"},
              // //                   );
              //
              // //                   setState(() {
              // //                     textButtonStop = 'Stopped';
              // //                     textButtonStart = 'Resume Service';
              // //                     isStopDisabled = true;
              // //                     isResumeDisabled = false;
              // //                   });
              // //                 }
              // //               }
              // //             }),
              // //         ElevatedButton.icon(
              // //             onPressed: () async {
              // //               var isRunning = await FlutterBackgroundService()
              // //                   .isServiceRunning();
              // //               if (isResumeDisabled) {
              // //                 null;
              // //               } else {
              // //                 if (isRunning) {
              // //                   FlutterBackgroundService().sendData(
              // //                     {"action": "restartService"},
              // //                   );
              // //                   setState(() {
              // //                     isResumeDisabled = true;
              // //                     isStopDisabled = false;
              // //                     textButtonStop = 'Stop Service';
              // //                     textButtonStart = 'Resumed';
              // //                   });
              // //                 }
              // //               }
              // //             },
              // //             icon: Icon(Icons.play_arrow),
              // //             label: Text("Resume")),
              // //       ],
              // //     )),
              // // StreamBuilder<Map<String, dynamic>?>(
              // //   stream: FlutterBackgroundService().onDataReceived,
              // //   builder: (context, snapshot) {
              // //     if (!snapshot.hasData) {
              // //       return Center(
              // //         child: CircularProgressIndicator(),
              // //       );
              // //     }
              // //     final data = snapshot.data!;
              // //     return Column(children: [
              // //       Text('Nilai Accelerometer',
              // //           style: TextStyle(fontWeight: FontWeight.bold)),
              // //       SizedBox(
              // //         height: 5,
              // //       ),
              // //       Text("Timer : ${data["time"]}"),
              // //       Container(
              // //           child: Column(
              // //         crossAxisAlignment: CrossAxisAlignment.start,
              // //         children: [
              // //           Text(
              // //               'index = ${data["accel_i"]}\nx = ${data["acc_x"]}\ny = ${data["acc_y"]}\nz = ${data["acc_y"]}'),
              // //           SizedBox(
              // //             height: 2,
              // //           ),
              // //           Text('amplitude = ${data["amplitude"]}\n'),
              // //           Text('min alpha = ${data["min_alpha"]}\n'),
              // //           Text('max alpha = ${data["max_alpha"]}\n'),
              // //         ],
              // //       )),
              // //       Text('Kondisi : ${data['is_fall']}'),
              // //       SizedBox(
              // //         height: 20,
              // //       ),
              // //       Text('ALERT : ${data['jatuh_label']}',
              // //           style:
              // //               TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
              // //     ]);
              // //   },
              // // ),
            ],
          ),
        ),
      );

  bool checkFallOrNot(List<double> arrAccel) {
    final n = arrAccel.length;

    for (int i = 0; i < n; i++) {
      if (arrAccel[i] < LOW_THRESHOLD_ACCELEROMETER) {
        for (int j = i + 1; j < n; j++) {
          return arrAccel[j] > HIGH_THRESHOLD_ACCELEROMETER;
        }
      }
    }

    return false;
  }
}
