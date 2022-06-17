
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fall_detection_v2/Models/history.dart';
import 'package:fall_detection_v2/Models/notifikasi.dart';
import 'package:fall_detection_v2/Screens/login.dart';
import 'package:fall_detection_v2/Widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Controllers/contact_controller.dart';

class NotifikasiPage extends StatefulWidget {
  @override
  _NotifikasiPageState createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  bool isAuth = false;
  late Future<List<History>> futureListHistory;
  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user_storage = localStorage.getString('user');
    if (token != null&&user_storage!=null) {
      futureListHistory = ContactController().getHistories() as Future<List<History>>;
      setState(() {
        isAuth = true;
      });
    }
  }
  @override
  void initState() {
    _checkIfLoggedIn();
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
        body: isAuth==true ?
        FutureBuilder<List<History>>(
          future: futureListHistory,
          builder: (context, historyData) {
            if (historyData.hasData)
            {
                if(historyData.data!.length>0){
                  return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: historyData.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  Card(
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: ListTile(
                                  title:
                                  Text(historyData.data![index].title, style: TextStyle(color: Colors.lightBlue, fontSize: 16)),
                                  subtitle: Text(historyData.data![index].description, style: TextStyle(color: Colors.grey, fontSize: 14)),
                                )));
                      });
                } else {
                  return Center(child: Text('Tidak ada data notifikasi ditemukan'));
                }

            }
            else if (historyData.hasError) {
              return Text('${historyData.error}');
            }
            // By default, show a loading spinner.
            return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ));

          },
        ) : Padding(padding : EdgeInsets.all(30), child : Column(
          children: [
            Text('Untuk melihat notifikasi, mohon login terlebih dahulu', style : TextStyle(fontSize: 15), textAlign : TextAlign.center),
            SizedBox(height : 10),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }, child: const Text('Login'))
          ],
        )),
      bottomNavigationBar: BottomNavbar(current : 1),

    );
  }
}


