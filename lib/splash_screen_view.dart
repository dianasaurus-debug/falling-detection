import 'dart:async';
import 'dart:ui';

import 'package:fall_detection_v2/index.dart';
import 'package:fall_detection_v2/index_unauthenticated.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget{
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState(){
    super.initState();
    startSpashScreen();
  }
  startSpashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, (){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_){
            return IndexUnauthenticated();
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