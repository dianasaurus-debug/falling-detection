import 'dart:async';
import 'dart:ui';

import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/accelerometer.dart';
import 'package:fall_detection_v2/Models/gyrometer_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'Models/accelerometer_graph.dart';

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
  List<AccelerometerGraph> chartData = [];
  List<GyroGraph> chartDataGyro = [];

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
              FlatButton(
                child: Text(textButtonStop),
                color: isStopDisabled == false ? Colors.lightBlue :  Colors.lightBlue.withOpacity(0.3),
                onPressed: () async {
                  chartData.clear();
                  chartDataGyro.clear();
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
              StreamBuilder<Map<String, dynamic>?>(
                stream: FlutterBackgroundService().onDataReceived,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final data = snapshot.data!;
                  chartData.add(new AccelerometerGraph(data["accel_i"], data["acc_x"].toString(), data["acc_y"].toString(), data["acc_z"].toString()));
                  return
                    Column(
                        children: [
                          Text('Nilai Accelerometer',style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 2,
                          ),
                          Text('index = ${data["accel_i"]}\nx = ${data["acc_x"]}\ny = ${data["acc_y"]}\nz = ${data["acc_y"]}'),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Grafik Accelerometer',style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                                        child:SfCartesianChart(

                                            // Initialize category axis
                                            primaryXAxis: CategoryAxis(maximumLabels: 3),
                                            series: <ChartSeries>[
                                              // Initialize line series
                                              StackedLineSeries<AccelerometerGraph, String>(
                                                dataSource: chartData,
                                                xValueMapper: (AccelerometerGraph accelerometer, _) => accelerometer.acc_i,
                                                yValueMapper: (AccelerometerGraph accelerometer, _) => double.parse(accelerometer.acc_x),
                                              ),
                                              StackedLineSeries<AccelerometerGraph, String>(
                                                dataSource: chartData,
                                                xValueMapper: (AccelerometerGraph accelerometer, _) => accelerometer.acc_i,
                                                yValueMapper: (AccelerometerGraph accelerometer, _) => double.parse(accelerometer.acc_y),
                                              ),
                                              StackedLineSeries<AccelerometerGraph, String>(
                                                dataSource: chartData,
                                                xValueMapper: (AccelerometerGraph accelerometer, _) => accelerometer.acc_i,
                                                yValueMapper: (AccelerometerGraph accelerometer, _) => double.parse(accelerometer.acc_z),
                                              ),
                                            ],
                                        )
                                    ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Nilai Gyroscope',style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 2,
                          ),
                          Text('index = ${data["gyro_i"]}\nx = ${data["gyro_x"]}\ny = ${data["gyro_y"]}\nz = ${data["gyro_y"]}', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Grafik Gyroscope',style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                              child:SfCartesianChart(

                                // Initialize category axis
                                primaryXAxis: CategoryAxis(maximumLabels: 3),
                                series: <ChartSeries>[
                                  // Initialize line series
                                  StackedLineSeries<GyroGraph, String>(
                                    dataSource: chartDataGyro,
                                    xValueMapper: (GyroGraph gyro, _) => gyro.gyro_i,
                                    yValueMapper: (GyroGraph gyro, _) => double.parse(gyro.gyro_x),
                                  ),
                                  StackedLineSeries<GyroGraph, String>(
                                    dataSource: chartDataGyro,
                                    xValueMapper: (GyroGraph gyro, _) => gyro.gyro_i,
                                    yValueMapper: (GyroGraph gyro, _) => double.parse(gyro.gyro_y),
                                  ),
                                  StackedLineSeries<GyroGraph, String>(
                                    dataSource: chartDataGyro,
                                    xValueMapper: (GyroGraph gyro, _) => gyro.gyro_i,
                                    yValueMapper: (GyroGraph gyro, _) => double.parse(gyro.gyro_z),
                                  ),
                                ],
                              )
                          )
                              ]);

                },
              ),
              SizedBox(
                height: 10,
              ),

            ],
          ),
        ));
  }
}
