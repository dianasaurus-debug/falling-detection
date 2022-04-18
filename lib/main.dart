import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/gyrometer.dart';
import 'package:fall_detection_v2/beranda.dart';
import 'package:fall_detection_v2/detect_falls.dart';
import 'package:fall_detection_v2/Screens/splash_screen.dart';
import 'package:fall_detection_v2/testing_sensor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sensors/sensors.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

import 'Utils/constants.dart';

// @dart=2.9
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart);
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Splash Screen',
    home: SplashScreenPage(),
    theme: ThemeData(fontFamily: 'Poppins', scaffoldBackgroundColor: Colors.white),

  ));
}
Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  List<List<dynamic>> rows = <List<dynamic>>[];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  const String URL = "https://script.google.com/macros/s/AKfycbzge5uO8rlaDrSHAxXd3qUTPtbAYiykh3XTO0n_yDVW86igQHn731NfgoVu4ujz01qK/exec";
  const STATUS_SUCCESS = "SUCCESS";
  void submitForm(List<Accelerometer> accelerometer, List<Gyrometer> gyrometer, void Function(String) callback) async {
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
  List<double> accelerometer_values = [];
  AudioPlayer player = AudioPlayer();

  List<Gyrometer> gyroscope = [];
  late Timer _timer;
  int _start = 2;
  double getMax(arr){
    var newarr = arr.sort();
    return newarr.last();
  }
  double getMin(arr){
    var newarr = arr.sort();
    return newarr.first();
  }
  bool checkFallOrNot(arr_accel){
    int n = arr_accel.length;
    for (int i = 0; i < n; i++) {
      if (arr_accel[i] < LOW_THRESHOLD_ACCELEROMETER) {
        for (int j = i + 1; j < n; j++) {
          if (arr_accel[j] > HIGH_THRESHOLD_ACCELEROMETER){
            return true;
          }
        }
      }
    }
    return false;
  }
  bool longlieDetection(arr_accel) {
    var min_value = getMin(arr_accel);
    var max_value = getMax(arr_accel);
    if (min_value >= LOW_LONGLIE_ACCELEROMETER && max_value <= HIGH_LONGLIE_ACCELEROMETER) {
      return true;
    }
    return false;
  }
  void ringtone_play() async{
    String audioasset = "audios/ringtone2.mp3";
    ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
    Uint8List  soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    int result = await player.playBytes(soundbytes);
    if(result == 1){ //play success
      print("Sound playing successful.");
    }else{
      print("Error while playing sound.");
    }
  }
  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Anda jatuh!"),
        ));
  }

  void startTimer(double value) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
            timer.cancel();
            if(accelerometer_values.length>0){
              if(checkFallOrNot(accelerometer_values)==true){
                for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
                  if (!(subscription.isPaused ?? true)) {
                    subscription.pause();
                    Timer(Duration(seconds: 5), () {
                      service.sendData(
                          {"jatuh_label":'Kamu Jatuh!',}
                      );
                    });
                  }
                }
                // Timer(Duration(seconds: 5), () {
                //   ringtone_play();
                // });
              } else {
                Timer(Duration(seconds: 5), () {
                  service.sendData(
                      {"is_fall":'Tidak'
                      }
                  );
                  // ringtone_play();
                });

              }
            }
            accelerometer_values = [];
            _start = 2;
        } else {
          accelerometer_values.add(value);
          _start--;
        }
      },
    );
  }
  if (_streamSubscriptions.length==0) {
    _streamSubscriptions.add(accelerometerEvents.listen((AccelerometerEvent event) {
      var amplitude_sum = pow(event.x,2)+pow(event.y,2)+pow(event.z,2);
      startTimer(sqrt(amplitude_sum));
      service.sendData(
        {
          "accel_i": accelerometer.length.toString(),
          "acc_x" : event.x,
          "acc_y" : event.y,
          "acc_z" : event.z,
          "amplitude" : sqrt(amplitude_sum),
          "time" : null
        }
      );
      // accelerometer.add(new Accelerometer(event.x.toString(), event.y.toString(), event.z.toString()));
    }));

    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      // omega[j] = sqrt(pow(event.x,2)+pow(event.y,2)+pow(event.z,2));
      // gyro_value = event;
      service.sendData(
          {"gyro_i": accelerometer.length.toString(),
            "gyro_x" : event.x,
            "gyro_y" : event.y,
            "gyro_z" : event.z,
            // "amplitude" : sqrt(omega[j]),
          }
      );
      // j = (j+1)%1000000;
      // gyroscope.add(new Gyrometer(event.x.toString(), event.y.toString(), event.z.toString()));
    }));


  }
  service.onDataReceived.listen((event) {
    if (event!["action"] == "stopService") {
      print('stopped');
      // submitForm(accelerometer, gyroscope, (response) {
      //   print("Response: $response");
      // });
      for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
        if (!(subscription.isPaused ?? true)) {
          subscription.pause();
        }
      }
      // service.stopBackgroundService();
    } else if(event!["action"] == "restartService"){
      FlutterBackgroundService.initialize(onStart);
      print('restarted');
      // i=0;
      // k=0;
      accelerometer = [];
      gyroscope = [];
      for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
        if ((subscription.isPaused ?? true)) {
          subscription.resume();
        }
      }
    }
  });


  // service.sendData(
    //   {"current_date": DateTime.now().toIso8601String()},
    // );
  // });
}