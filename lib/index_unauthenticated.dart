import 'package:fall_detection_v2/login.dart';
import 'package:fall_detection_v2/register.dart';
import 'package:flutter/material.dart';

class IndexUnauthenticated extends StatelessWidget {
  final ButtonStyle styleButtonIndex = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      primary: Color(0xff7A99B4), // background
      onPrimary: Colors.white, // foreground
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "images/bg_index.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Text('Human\nFall Detection', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(height: 500,)
                  ]
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                )

            ]
          ),
        ),
      ),
    );
  }
}