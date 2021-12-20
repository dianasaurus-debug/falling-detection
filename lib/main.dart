import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/gyrometer.dart';
import 'package:fall_detection_v2/detect_falls.dart';
import 'package:fall_detection_v2/splash_screen_view.dart';
import 'package:fall_detection_v2/testing_sensor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sensors/sensors.dart';
import 'package:http/http.dart' as http;

// @dart=2.9
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // FlutterBackgroundService.initialize(onStart);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Splash Screen',
    home: DetectFalls(),
  ));
}
void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  List<List<dynamic>> rows = <List<dynamic>>[];
  const String URL = "https://script.google.com/macros/s/AKfycbyANfT3HN5lIDw44QYWvdGvqDS8j-vk0H2S56rSbpWtqnFduy8CgM3LrsftDk-1va38/exec";
  const STATUS_SUCCESS = "SUCCESS";
  void submitForm(
      List<Accelerometer> accelerometer, List<Gyrometer> gyrometer, void Function(String) callback) async {
    var jsonDataAccelerometer = accelerometer.map((e) => e.toJson()).toList();
    var jsonDataGyro= gyrometer.map((e) => e.toJson()).toList();
    var jsonAll = {
      'accelerometer' : jsonDataAccelerometer,
      'gyroscope' : jsonDataGyro
    };
    try {
      await http.post(Uri.parse(URL), body: json.encode(jsonAll)).then((response) async {

        service.sendData(
            {"status_data":"PROSES DIRECORD!"}
        );
        if (response.statusCode == 302) {
          var url = response.headers['location'];
            await http.get(Uri.parse(url!)).then((response) {
              callback(convert.jsonDecode(response.body).toString());
              print(jsonDecode(response.body));
              service.sendData(
                  {"status_data":"SELESAI DIRECORD!"}
              );
            }
          );
        } else {
          callback(convert.jsonDecode(response.body).toString());
          print(jsonDecode(response.body));
          service.sendData(
              {"status_data":"GAGAL DIRECORD!"}
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }
  List<Accelerometer> accelerometer = [];
  List<Gyrometer> gyroscope = [];

  int i=0;
  int k=0;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  if (_streamSubscriptions.length==0) {
    _streamSubscriptions.add(accelerometerEvents.listen((AccelerometerEvent event) {
      service.setNotificationInfo(
        title: "Tes background app",
        content: "i = $i x = ${event.x}, y = ${event.y}, z = ${event.z}",
      );
      print("Accel : i = $i. x = ${event.x}, y = ${event.y}, z = ${event.z}");
      service.sendData(
        {"accel_i": accelerometer.length.toString(),
          "acc_x" : event.x,
          "acc_y" : event.y,
          "acc_z" : event.z,
        }
      );
      accelerometer.add(new Accelerometer(event.x.toString(), event.y.toString(), event.z.toString()));

      i++;
    })
    );
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      service.setNotificationInfo(
        title: "Tes background app",
        content: "Gyro : i = $k x = ${event.x}, y = ${event.y}, z = ${event.z}",
      );
      print("Gyro : i = $k. x = ${event.x}, y = ${event.y}, z = ${event.z}");
      service.sendData(
          {"gyro_i": accelerometer.length.toString(),
            "gyro_x" : event.x,
            "gyro_y" : event.y,
            "gyro_z" : event.z,
          }
      );
      gyroscope.add(new Gyrometer(event.x.toString(), event.y.toString(), event.z.toString()));
      k++;
    }));

  }
  service.onDataReceived.listen((event) {
    if (event!["action"] == "stopService") {
      print('stopped');
      submitForm(accelerometer, gyroscope, (response) {
        print("Response: $response");
      });
      for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
        if (!(subscription.isPaused ?? true)) {
          subscription.pause();
        }
      }
      // service.stopBackgroundService();
    } else if(event!["action"] == "restartService"){
      // FlutterBackgroundService.initialize(onStart);
      print('restarted');
      i=0;
      k=0;
      accelerometer = [];
      gyroscope = [];
      for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
        subscription.resume();
      }
    }
  });


  // service.sendData(
    //   {"current_date": DateTime.now().toIso8601String()},
    // );
  // });
}