import 'package:fall_detection_v2/login.dart';
import 'package:fall_detection_v2/register.dart';
import 'package:fall_detection_v2/testing_sensor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class IndexUnauthenticated extends StatelessWidget {
  final ButtonStyle styleButtonIndex = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      primary: Color(0xff7A99B4), // background
      onPrimary: Colors.white, // foreground
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Human Fall Detection', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height:10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          child: Text('Tes Sensor'),
                          onPressed: () async {
                            Route route = MaterialPageRoute(
                                builder: (context) => TestingSensor());
                            Navigator.push(context, route);
                          },
                        ),
                        ElevatedButton(
                          style : styleButtonIndex,
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => Login());
                            Navigator.push(context, route);
                          },
                          child: const Text('LOGIN', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: 'Roboto')),
                        ),
                        ElevatedButton(
                          style : styleButtonIndex,
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => Register());
                            Navigator.push(context, route);
                          },
                          child: const Text('REGISTER', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: 'Roboto')),
                        ),
                      ],
                    ),
                  ]
                ),

        ),
      ),
    );
  }
}