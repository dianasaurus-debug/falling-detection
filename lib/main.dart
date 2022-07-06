// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

// import 'dart:typed_data';
// import 'dart:convert' as convert;
// import 'dart:convert';

import 'package:fall_detection_v2/Controllers/auth_controller.dart';
import 'package:fall_detection_v2/Models/contact.dart';
import 'package:fall_detection_v2/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fall_detection_v2/Utils/disposable_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:vibration/vibration.dart';
import 'package:overlay_support/overlay_support.dart';

import 'Controllers/contact_controller.dart';
import 'Utils/constants.dart';
Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');
}
// import 'package:http/http.dart' as http;
LatLng myPosition;
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationManager.Location location = new LocationManager.Location();
StreamSubscription accel;
double _lat = -7.317463;
double _lng = 111.761466;
CameraPosition _currentPosition = CameraPosition(
  target: LatLng(_lat, _lng),
  zoom: 12,
);

Completer<GoogleMapController> _controller = Completer();
var isAuth = false;
var user = null;

_locateMe() async {
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == LocationManager.PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != LocationManager.PermissionStatus.granted) {
      return;
    }
  }
  await location.getLocation().then((res) async {
    final GoogleMapController controller = await _controller.future;
    _lat = res.latitude;
    _lng = res.longitude;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  _locateMe();

  runApp(
      OverlaySupport(
        child:
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Human Fall Detection',
      home: SplashScreenPage(),
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
    )),
  );
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  String status = "Status";
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  accelerometerEvents.listen((event) => {});

  if (_streamSubscriptions.length == 0) {
    _streamSubscriptions
        .add(accel = accelerometerEvents.listen((AccelerometerEvent event) {
      final data = event;
      final x = data?.x ?? 0;
      final y = data?.y ?? 0;
      final z = data?.z ?? 0;
      final gx = x / 9.80665;
      final gy = y / 9.80665;
      final gz = z / 9.80665;
      var gForce = sqrt(pow(gx, 2) + pow(gy, 2) + pow(gz, 2));
      const gravityThreshold = 2.7;
      if (gForce > gravityThreshold) {
        final now = DateTime.now().millisecondsSinceEpoch;
        const delay = 1000;
        if (timestamp + delay < now) {
          Vibration.vibrate(duration: 2000);
          ContactController().getContacts().then((contacts) {
              for (ContactModel contact in contacts) {
                String newString = contact.phone.replaceFirst(RegExp(r'0'), '62');
                String usedPhone = newString.replaceAll(RegExp(r"\D"), "");
                Future.delayed(Duration(milliseconds: 3000), () {
                  _send_message(usedPhone);
                });
              }
              _add_to_history();
            });
        }

      }

    }));
  }
}

void _send_message(phone) async {
  var data = {
    'phone': phone,
    'latitude': _lat,
    'longitude': _lng,
    'nama_lokasi': 'Tempat jatuh',
    'detail_lokasi': 'Jln Ah yani'
  };

  var res = await AuthController().postData(data, '/send/whatsapp');
  // var body = json.decode(res.body);
  print('send_message : ');
  print(res.body);
  // if(body['success']){
  //  print(body['message']);
  //  print('sukses!');
  // }else{
  //   print(body['message']);
  //   print('gagal!');
  // }
}

void _add_to_history() async {
  var data = {
    'latitude': _lat,
    'longitude': _lng,
  };

  var res = await AuthController().postData(data, '/history/create');
  var body = json.decode(res.body);
  print(res.body);
  // if(body['success']){
  //   print(body['message']);
  //   print('sukses!');
  // }else{
  //   print(body['message']);
  //   print('gagal!');
  // }
}
