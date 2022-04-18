import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors/sensors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  bool isAuth = false;
  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }
  @override
  void initState() {
    _checkIfLoggedIn();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (isAuth == true) ...[
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('images/leon.jpg'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Halo, Faisal Habib Rozaqqi!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'faisal@gmail.com',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.location, size: 13),
                                      Text('Gebang Putih, Sukolilo Surabaya',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ]))
                      ] else ...[
                        Text('Login'),
                        Text('  |  '),
                        Text('Daftar')
                      ],
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: Colors.blueAccent,
                            width: 0.0
                        ),
                        color: Colors.blueAccent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 24,
                                child: Icon(CupertinoIcons.person_add, size: 30)),
                            SizedBox(height: 3),
                            Text('Menu 1', style: TextStyle(color: Colors.white, fontSize : 12),)
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 24,
                              child: Icon(Icons.add_location, size: 30),
                            ),
                            SizedBox(height: 3),
                            Text('Menu 2', style: TextStyle(color: Colors.white, fontSize : 12),)
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 24,
                              child: Icon(Icons.add_call, size: 30),
                            ),
                            SizedBox(height: 3),
                            Text('Menu 3', style: TextStyle(color: Colors.white, fontSize : 12),)
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 24,
                              child: Icon(CupertinoIcons.checkmark_shield, size: 30),
                            ),
                            SizedBox(height: 3),
                            Text('Menu 4', style: TextStyle(color: Colors.white, fontSize : 12),)
                          ],
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children :[
                      Text('Keluarga Dekat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        SizedBox(height: 13),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('images/leon.jpg'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text('Ayah', style: TextStyle(color: Colors.black, fontSize : 12),)
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('images/leon.jpg'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text('Ibu', style: TextStyle(color: Colors.black, fontSize : 12),)
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('images/leon.jpg'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text('Adek', style: TextStyle(color: Colors.black, fontSize : 12),)
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('images/leon.jpg'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text('Paman', style: TextStyle(color: Colors.black, fontSize : 12),)
                            ],
                          ),

                        ],
                      ),
                    ]
                  ),
                  SizedBox(height: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children :[
                        Text('Lokasi saya sekarang', style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold)),
                        SizedBox(height: 13),
                        Container (
                          height: 200,
                          child : GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(3.595196, 98.672226),
                              zoom: 14.0,
                            ),
                          ),
                        )
                      ]
                  ),
                  SizedBox(height: 10),
                ])
        )
    );
  }
}
