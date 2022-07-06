
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fall_detection_v2/Controllers/auth_controller.dart';
import 'package:fall_detection_v2/Screens/change_password.dart';
import 'package:fall_detection_v2/Screens/detail_profile.dart';
import 'package:fall_detection_v2/Screens/faq.dart';
import 'package:fall_detection_v2/Screens/login.dart';
import 'package:fall_detection_v2/Screens/notifikasi_list.dart';
import 'package:fall_detection_v2/Widgets/bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sensors/sensors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
  late FirebaseMessaging messaging;

  @override
  void initState() {
   super.initState();

   messaging = FirebaseMessaging.instance;
   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
     showSimpleNotification(
       Text(event.notification!.title!, style:TextStyle(fontSize: 16, color: Colors.indigo)),
       subtitle: Text(event.notification!.body!, style:TextStyle(fontSize: 13, color: Colors.black)),
       background: Colors.white,
       duration: Duration(seconds: 20),
     );
   });
   FirebaseMessaging.onMessageOpenedApp.listen((message) {
     Route route = MaterialPageRoute(
         builder: (context) => NotifikasiPage());
     Navigator.push(context, route);
   });
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Profil', style: TextStyle(color : Colors.black),),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        body: isAuth == true ? SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('images/icon_profile.png'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.lightBlue,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailProfile()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            const IconData(58513, fontFamily: 'MaterialIcons'),
                            color: Colors.grey,
                            size: 22,
                          ),
                          // SvgPicture.asset(
                          //   icon,
                          //   color: kPrimaryColor,
                          //   width: 22,
                          // ),
                          SizedBox(width: 20),
                          Expanded(child: Text('Akun saya', style: TextStyle(fontSize: 17))),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.lightBlue,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotifikasiPage()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            const IconData(58447, fontFamily: 'MaterialIcons'),
                            color: Colors.grey,
                            size: 22,
                          ),

                          SizedBox(width: 20),
                          Expanded(child: Text('Notifikasi', style: TextStyle(fontSize: 17))),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.lightBlue,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpdatePassword()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            const IconData(58751, fontFamily: 'MaterialIcons'),
                            color: Colors.grey,
                            size: 22,
                          ),
                          // SvgPicture.asset(
                          //   icon,
                          //   color: kPrimaryColor,
                          //   width: 22,
                          // ),
                          SizedBox(width: 20),
                          Expanded(child: Text('Ubah Password', style: TextStyle(fontSize: 17))),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.lightBlue,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FAQPage()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            const IconData(58122, fontFamily: 'MaterialIcons'),
                            color: Colors.grey,
                            size: 22,
                          ),
                          // SvgPicture.asset(
                          //   icon,
                          //   color: kPrimaryColor,
                          //   width: 22,
                          // ),
                          SizedBox(width: 20),
                          Expanded(child: Text('Bantuan', style: TextStyle(fontSize: 17))),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.lightBlue,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: (){
                        logout();
                      },
                      child: Row(
                        children: [
                          Icon(
                            const IconData(58291, fontFamily: 'MaterialIcons'),
                            color: Colors.grey,
                            size: 22,
                          ),
                          // SvgPicture.asset(
                          //   icon,
                          //   color: kPrimaryColor,
                          //   width: 22,
                          // ),
                          SizedBox(width: 20),
                          Expanded(child: Text('Log Out', style: TextStyle(fontSize: 17))),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              color: Colors.white,
            )
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
      bottomNavigationBar: BottomNavbar(current : 3),

    );
  }
  void logout() async {
    var res = await AuthController().postData({},'/logout');
    var body = json.decode(res.body);
    print(body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Login()));
    }
  }
}
