
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fall_detection_v2/Models/notifikasi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors/sensors.dart';

class NotifikasiPage extends StatefulWidget {
  @override
  _NotifikasiPageState createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {

  @override
  void initState() {
    // TODO: implement initState
  }
  List<NotificationModel> notifikasi_list = [
    new NotificationModel(1, 'Notifikasi test 1', 'Detail notifikasi'),
    new NotificationModel(1, 'Notifikasi test 1', 'Detail notifikasi'),
    new NotificationModel(1, 'Notifikasi test 1', 'Detail notifikasi'),
    new NotificationModel(1, 'Notifikasi test 1', 'Detail notifikasi'),
    new NotificationModel(1, 'Notifikasi test 1', 'Detail notifikasi'),
  ];
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Notifikasi',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Color(0xff80cbc4), //change your color here
          ),
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: notifikasi_list.length,
            itemBuilder: (BuildContext context, int index) {
              return  Card(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        title:
                        Text(notifikasi_list[index].title, style: TextStyle(color: Colors.lightBlue, fontSize: 16)),
                        subtitle: Text(notifikasi_list[index].content, style: TextStyle(color: Colors.grey, fontSize: 14)),
                      )));
            })
    );
  }
}


