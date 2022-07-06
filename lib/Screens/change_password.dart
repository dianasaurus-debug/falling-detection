import 'dart:convert';

import 'package:fall_detection_v2/Controllers/auth_controller.dart';
import 'package:fall_detection_v2/Screens/notifikasi_list.dart';
import 'package:fall_detection_v2/Screens/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


// Define a custom Form widget.
class UpdatePassword extends StatefulWidget {
  @override
  UpdatePasswordState createState() {
    return UpdatePasswordState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class UpdatePasswordState extends State<UpdatePassword> {
  var password;
  var new_password;
  var new_confirm_password;


  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  late FirebaseMessaging messaging;

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
  @override
  Widget build(BuildContext context) {
    final ButtonStyle styleLogin = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      primary: Color(0xff000000), // background
      onPrimary: Colors.white, // foreground
      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
    );
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.lightBlue, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title:Text('Ubah Password', style: TextStyle(color: Colors.black, fontSize : 20),),
          elevation: 0,
          backgroundColor: Color(0xffffffff),
        ),
        extendBodyBehindAppBar: true,
        body:SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20,20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.indigo, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xff000000), width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          hintText: 'Password Lama',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field tidak boleh kosong';
                          }
                          setState(() {
                            password = value;
                          });
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.indigo, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xff000000), width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          hintText: 'Password Baru',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field tidak boleh kosong';
                          }
                          setState(() {
                            new_password = value;
                          });
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.indigo, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xff000000), width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          hintText: 'Konfirmasi Password Baru',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field tidak boleh kosong';
                          } else {
                            if(value!=new_password){
                              return 'Konfirmasi password baru harus sama';
                            } else {
                              setState(() {
                                new_confirm_password = value;
                              });
                            }
                          }
                          return null;
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _update();
                              }
                            },
                            style: styleLogin,
                            child: Text(
                              _isLoading ? 'Loading...' : 'Update',
                            ),
                          )),
                      const SizedBox(height: 10),
                    ],
                  ),
                )))


    );
  }
  void _update() async{
    setState(() {
      _isLoading = true;
    });
    var  data = {
      'password' : password,
      'new_password' : new_password,
    };
    var res = await AuthController().postData(data, '/change/password');
    var body = json.decode(res.body);
    print(res.body);
    if(body['success']){
      Alert(
        context: context,
        type: AlertType.success,
        title: "Sukses update password!",
        desc: body['message'],
        buttons: [
          DialogButton(
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ProfilePage()
                  ),
                );
              },
              width: 120
          )
        ],
      ).show();

    }else{
      print(data);
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal Update!",
        desc: body['message'],
        buttons: [
          DialogButton(
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
    setState(() {
      _isLoading = false;
    });
  }

}
