
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fall_detection_v2/Screens/beranda.dart';
import 'package:fall_detection_v2/Screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class FallAlert extends StatefulWidget {
  final bool isAuth;
  const FallAlert({Key? key, required this.isAuth}) : super(key: key);
  @override
  _FallAlertState createState() => _FallAlertState();
}

class _FallAlertState extends State<FallAlert> {

  @override
  void initState() {
    // TODO: implement initState
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Color(0xff80cbc4), //change your color here
          ),
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Beranda()),
            )
          ),
        ),
        body: widget.isAuth == true ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Column(
                    children: [
                      Icon(Icons.warning, color : Colors.red, size: 50),
                      Text('Anda Terjatuh!!'),
                      Text('Sudah dikirim notifikasi ke kontak darurat!')
                    ],
                  )
              )
            ],
          ),
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Column(
                  children: [
                    Icon(Icons.warning, color : Colors.red, size: 50),
                    Text('Anda Terjatuh!!'),
                    Text('Mohon login dahulu untuk mengirim notifikasi ke kontak Anda!'),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        }, child: const Text('Login'))
                  ],
                )
            )
          ],
        )
    );
  }
}
