import 'dart:convert';
import 'package:fall_detection_v2/Controllers/sensors.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Models/get_excel_accelerometer.dart';

class DetectFalls extends StatefulWidget {
  @override
  _DetectFallsState createState() => _DetectFallsState();
}

class _DetectFallsState extends State<DetectFalls> {
  late Future<dynamic> futureAllAccelerometerData;
  var recent_value = 199;
  var users = ['Ghulam', 'Faisal', 'Gholyf', 'Aqsa', 'Ramdhan'];
  @override
  void initState() {
    super.initState();
    futureAllAccelerometerData = SensorController().getAllAccelerometerValues();
  }

  String checkFallOrNot(arr_accel, length){
    int n = length;
    int nilai_awal = 0;
    if(n!=199){
      nilai_awal = length-199;
    }
    print(nilai_awal);
    for (int i = nilai_awal; i < n; i++) {
      if (double.parse(arr_accel[i].value) < LOW_THRESHOLD_ACCELEROMETER) {
        for (int j = i + 1; j < n; j++) {
          if (double.parse(arr_accel[j].value) > HIGH_THRESHOLD_ACCELEROMETER){
            return "Jatuh!\nNilai Accelerometer : ${double.parse(arr_accel[j].value)}";
          }
        }
      }
    }
    return "Tidak jatuh!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test detect fall"),
      ),
      body:
          SingleChildScrollView (
            child :FutureBuilder<dynamic>(
                        future: futureAllAccelerometerData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return
                              Column(
                                children : [
                                  for ( var i = 0;i<5;i++ )
                                  Padding(
                                padding : EdgeInsets.all(20),
                                child : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Hasil pengukuran user ${users[i]}:\n'),
                                      Text("falling.csv => ${checkFallOrNot(snapshot.data['arr_falling'], recent_value+(200*i))}\n"),
                                      Text("sitting.csv => ${checkFallOrNot(snapshot.data['arr_sitting'], recent_value+(200*i))}\n"),
                                      Text("walking.csv => ${checkFallOrNot(snapshot.data['arr_walking'], recent_value+(200*i))}\n"),
                                      Text("standing_up.csv => ${checkFallOrNot(snapshot.data['arr_standing_up'], recent_value+(200*i))}\n"),
                                      Text("sitting_down.csv => ${checkFallOrNot(snapshot.data['arr_sitting_down'], recent_value+(200*i))}\n"),
                                    ]
                                )
                            )
                                ]
                              );

                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          else
                          {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
          )


    );
  }
}
