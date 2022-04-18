import 'dart:async';
import 'dart:ui';

import 'package:fall_detection_v2/Screens/beranda.dart';
import 'package:fall_detection_v2/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget{
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool isAuth = false;
  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user_storage = localStorage.getString('user');
    if (token != null&&user_storage!=null) {
      setState(() {
        isAuth = true;
      });
    }
  }
  @override
  void initState(){
    super.initState();
    _checkIfLoggedIn();
    startSpashScreen();
  }

  startSpashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, (){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_){
            // return isAuth == true ? Beranda() : Login();
            return Beranda();
          })
      );
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Color(0xff89A9CB),
        body: Center(
            child:
            Padding(
              padding: const EdgeInsets.only(left: 30, right:30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Fall Detection',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white, fontFamily: 'Open Sans')),

                ],
              ),
            )
        )
    );
  }
}