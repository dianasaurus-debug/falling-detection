import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:fall_detection_v2/Controllers/auth_controller.dart';
import 'package:fall_detection_v2/Controllers/contact_controller.dart';
import 'package:fall_detection_v2/Models/contact.dart';
import 'package:fall_detection_v2/Screens/login.dart';
import 'package:fall_detection_v2/Screens/register.dart';
import 'package:fall_detection_v2/Widgets/bottom_bar.dart';
import 'package:fall_detection_v2/testing_sensor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  bool isAuth = false;
  var user = null;
  late Future<List<ContactModel>> futureListContact;
  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user_storage = localStorage.getString('user');
    if (token != null&&user_storage!=null) {
      futureListContact = ContactController().getContacts() as Future<List<ContactModel>>;
      setState(() {
        isAuth = true;
        user=jsonDecode(user_storage);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final Map<String, Marker> _markers = {};

  late LatLng myPosition;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationManager.Location location = new LocationManager.Location();
  double _lat = -7.317463;
  double _lng = 111.761466;
  late CameraPosition _currentPosition = CameraPosition(
    target: LatLng(_lat, _lng),
    zoom: 12,
  );

  Completer<GoogleMapController> _controller = Completer();
  _locateMe() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == LocationManager.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != LocationManager.PermissionStatus.granted) {
        return;
      }
    }
    await location.getLocation().then((res) async {
      final GoogleMapController controller = await _controller.future;
      final _position = CameraPosition(
        target: LatLng(res.latitude!, res.longitude!),
        zoom: 12,
      );
      controller.moveCamera(CameraUpdate.newLatLngZoom(LatLng(res.latitude!, res.longitude!), 12));
      //
      // controller.animateCamera(CameraUpdate.newCameraPosition(_position));
      setState(() {
        _currentPosition = CameraPosition(
          target: LatLng(res.latitude!, res.longitude!),
          zoom: 12,
        );
        _lat = res.latitude!;
        _lng = res.longitude!;
      });
    });
  }
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    setState(() {
      _markers['Lokasi saya'] = Marker(
        markerId: MarkerId('Lokasi saya'),
        position: LatLng(_lat, _lng),
        infoWindow: InfoWindow(
          title: 'Lokasi saya',
        ),
      );

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIfLoggedIn();
    _locateMe();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).size.height*(0.1), 10, 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  'Halo, ${user['name']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '${user['email']}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.location, size: 13),
                                    Text('${user['alamat']}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ]))
                    ] else ...[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: const Text('Login'),
                      ),
                      SizedBox(width: 10,),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: const Text('Daftar'),
                      ),
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
                if (isAuth == true) ...[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children :[
                            Text('Kontak Darurat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            SizedBox(height: 13),
                            FutureBuilder<List<ContactModel>>(
                              future: futureListContact,
                              builder: (context, contactData) {
                                if (contactData.hasData)
                                {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: contactData.data!
                                            .map((contact) => Container(
                                          margin : EdgeInsets.only(right : 10),
                                          child: Column(
                                            children: [
                                              CircleAvatar(child: Text(contact.name.substring(0, 1))),
                                              SizedBox(height: 3),
                                              Text('${contact.name}', style: TextStyle(color: Colors.black, fontSize : 12),)
                                            ],
                                          ),
                                        )).toList()));
                                } else if (contactData.hasError) {
                                  return Text('${contactData.error}');
                                }
                                // By default, show a loading spinner.
                                return Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ));

                              },
                            )
                          ]
                      ),
                ],
                SizedBox(height: 10),
                RaisedButton(
                  child: Text(
                    'Tes Sensor',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    _send_message();
                  },
                ),
                SizedBox(height: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children :[
                      Text('Lokasi saya sekarang', style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold)),
                      SizedBox(height: 13),
                      Container (
                        height: 300,
                        child : GoogleMap(
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          mapType: MapType.normal,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: _currentPosition,
                          markers: _markers.values.toSet(),
                        ),
                      )
                    ]
                ),
                SizedBox(height: 10),
              ])
      ),
      bottomNavigationBar: BottomNavbar(current : 0),
    );
  }
  void _send_message() async{
    print('pressed!');
    var data = {
      'phone' : '6283162937284',
      'latitude' : _lat,
      'longitude' : _lng,
      'nama_lokasi' : 'Tempat jatuh',
      'detail_lokasi' : 'Jln Ah yani'
    };

    var res = await AuthController().postData(data, '/send/whatsapp');
    var body = json.decode(res.body);
    print(res.body);
    if(body['success']){
      print(body['message']);
      print('sukses!');
    }else{
      print(body['message']);
      print('gagal!');
    }


  }
}
