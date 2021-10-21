
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors/sensors.dart';
import 'package:simple_permissions/simple_permissions.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  double x=0, y=0, z=0;
  double gx=0, gy=0, gz=0;
  @override
  void initState() {
    // TODO: implement initState
    getCsv() async {
      List<List<dynamic>> rows = <List<dynamic>>[];
      var i=1;
      // List<List<dynamic>> rows_gyro = <List<dynamic>>[];
      // List<List<dynamic>> gabungan = <List<dynamic>>[];
      //Optional for CSV Validation
      List<dynamic> AccelHeader = ['Accel_x', 'Accel_y', 'Accel_z', 'Gyro_x', 'Gyro_y', 'Gyro_z'];
      // List<dynamic> gyroHeader = ['Gyro_x', 'Gyro_y', 'Gyro_z'];
      rows.add(AccelHeader);
      // rows_gyro.add(gyroHeader);
      accelerometerEvents.listen((AccelerometerEvent event) {
        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;
        });
        List<dynamic> row = [];
        row.add(event.x);
        row.add(event.y);
        row.add(event.z);
        rows.add(row);
      });
      gyroscopeEvents.listen((GyroscopeEvent event) {
        setState(() {
          gx = event.x;
          gy = event.y;
          gz = event.z;
        });
        if(i>rows.length-1){
          List<dynamic> row = [];
          row.add('');
          row.add('');
          row.add('');
          row.add(event.x);
          row.add(event.y);
          row.add(event.z);
          rows.add(row);
        } else {
          rows[i].add(event.x);
          rows[i].add(event.y);
          rows[i].add(event.z);
        }
        i++;
      });
      await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
      bool checkPermission=await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
      if(checkPermission) {

//store file in documents folder

        String dir = (await getExternalStorageDirectory())!.absolute.path + "/documents";
        var file = "$dir";
        print(" FILE " + file);
        File f = new File(file+"_datasample.csv");
        // gabungan.add(rows);
        // gabungan.add(rows_gyro);
// convert rows to String and write as csv file
        String csv1 = const ListToCsvConverter().convert(rows);

        f.writeAsString(csv1);
      }
    }
    super.initState();
      getCsv();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Accelerometer",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
                ),
              ),
              Table(
                border: TableBorder.all(
                    width: 2.0,
                    color: Colors.blueAccent,
                    style: BorderStyle.solid),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "X Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(x.toStringAsFixed(2), //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Y Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(y.toStringAsFixed(2),  //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Z Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(z.toStringAsFixed(2),   //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Gyroscope",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
                ),
              ),
              Table(
                border: TableBorder.all(
                    width: 2.0,
                    color: Colors.blueAccent,
                    style: BorderStyle.solid),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "X Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(gx.toStringAsFixed(2), //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Y Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(gy.toStringAsFixed(2),  //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Z Axis : ",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(gz.toStringAsFixed(2),   //trim the asis value to 2 digit after decimal point
                            style: TextStyle(fontSize: 20.0)),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
