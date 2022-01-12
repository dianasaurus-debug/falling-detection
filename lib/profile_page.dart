
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors/sensors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    // TODO: implement initState
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Profil'),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
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
                          backgroundImage: AssetImage('images/leon.jpg'),
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => ProfileDetail()),
                        // );
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
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(
                            const IconData(58447, fontFamily: 'MaterialIcons'),
                            color: Colors.grey,
                            size: 22,
                          ),
                          // SvgPicture.asset(
                          //   icon,
                          //   color: kPrimaryColor,
                          //   width: 22,
                          // ),
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => SettingScreen()),
                        // );
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
                          Expanded(child: Text('Pengaturan', style: TextStyle(fontSize: 17))),
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
                        // Navigator.push(
                        //   context,
                        //   // MaterialPageRoute(builder: (context) => BantuanScreen()),
                        // );
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
                        // logout();
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
        )
    );
  }
}
