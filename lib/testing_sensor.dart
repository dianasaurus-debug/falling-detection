import 'dart:async';
import 'dart:ui';

import 'package:fall_detection_v2/Models/gyrometer_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
class TestingSensor extends StatefulWidget {
  @override
  _TestingSensorState createState() => _TestingSensorState();
}

class _TestingSensorState extends State<TestingSensor> {
  @override
  void initState() {
    super.initState();
  }

  var textButtonStop = 'Stop Service';
  var textButtonStart = 'Resume Service';
  var isStopDisabled = false;
  var isResumeDisabled = true;
  // List<AccelerometerGraph> chartData = [];
  // List<GyroGraph> chartDataGyro = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Testing Sensor',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Colors.blue, //change your color here
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child:
             Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom:10),
                  child: Wrap(
                    spacing: 10,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () async {
                            // chartData.clear();
                            // chartDataGyro.clear();
                            var isRunning =
                            await FlutterBackgroundService().isServiceRunning();
                            if(isStopDisabled){
                              null;
                            } else {
                              if (isRunning) {
                                FlutterBackgroundService().sendData(
                                  {"action": "stopService"},
                                );

                                setState(() {
                                  textButtonStop = 'Stopped';
                                  textButtonStart = 'Resume Service';
                                  isStopDisabled = true;
                                  isResumeDisabled = false;
                                });
                              }
                            }
                          },
                          icon: Icon(Icons.stop),
                          label:Text("Stop")
                      ),
                      ElevatedButton.icon(
                          onPressed: () async {
                            var isRunning =
                            await FlutterBackgroundService().isServiceRunning();
                            if(isResumeDisabled){
                              null;
                            } else {
                              if (isRunning) {
                                FlutterBackgroundService().sendData(
                                  {"action": "restartService"},
                                );
                                setState(() {
                                  isResumeDisabled = true;
                                  isStopDisabled = false;
                                  textButtonStop = 'Stop Service';
                                  textButtonStart = 'Resumed';
                                });
                              }
                            }
                          },
                          icon: Icon(Icons.play_arrow),
                          label:Text("Resume")
                      ),
                    ],
                  )
              ),
              StreamBuilder<Map<String, dynamic>?>(
                stream: FlutterBackgroundService().onDataReceived,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.data!;
                  return
                    Column(
                        children: [
                          Text('Nilai Accelerometer',style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Timer : ${data["time"]}"),
                          Container(
                              child: Column(
                                crossAxisAlignment : CrossAxisAlignment.start,
                                children: [
                                  Text('index = ${data["accel_i"]}\nx = ${data["acc_x"]}\ny = ${data["acc_y"]}\nz = ${data["acc_y"]}'),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text('amplitude = ${data["amplitude"]}\n'),
                                  Text('min alpha = ${data["min_alpha"]}\n'),
                                  Text('max alpha = ${data["max_alpha"]}\n'),
                                ],
                              )
                          ),
                          Text('Kondisi : ${data['is_fall']}'),
                          SizedBox(height: 20,),
                          Text('ALERT : ${data['jatuh_label']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
                              ]);

                },
              ),

            ],
          ),
        ));
  }

}
