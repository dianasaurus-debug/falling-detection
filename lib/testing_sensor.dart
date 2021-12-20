import 'dart:async';
import 'dart:ui';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Testing Sensor',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                      fontFamily: 'Open Sans')),
              SizedBox(
                height: 10,
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
                  print(data);
                  return Column(
                    children: [
                      Text('Sensor Accelerometer',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'Open Sans')),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        child: Column(
                          children: [
                            Text('Index : ${data["accel_i"]}'),
                            Text('x : ${data["acc_x"]}'),
                            Text('y : ${data["acc_y"]}'),
                            Text('z : ${data["acc_z"]}'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Sensor Gyroscope',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Open Sans')),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        child: Column(
                          children: [
                            Text('Index : ${data["gyro_i"]}'),
                            Text('x : ${data["gyro_x"]}'),
                            Text('y : ${data["gyro_y"]}'),
                            Text('z : ${data["gyro_z"]}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('Status Data Excel : ${data["status_data"]}')
                    ],
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                child: Text(textButtonStop),
                color: isStopDisabled == false ? Colors.lightBlue :  Colors.lightBlue.withOpacity(0.3),
                onPressed: () async {
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
              ),
              SizedBox(
                height: 5,
              ),
              FlatButton(
                child: Text(textButtonStart),
                color: isResumeDisabled == false ? Colors.lightBlue :  Colors.lightBlue.withOpacity(0.3),
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
              ),
            ],
          ),
        )));
  }
}
