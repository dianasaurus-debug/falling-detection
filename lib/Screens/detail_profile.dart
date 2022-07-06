import 'dart:convert';

import 'package:fall_detection_v2/Controllers/auth_controller.dart';
import 'package:fall_detection_v2/Screens/beranda.dart';
import 'package:fall_detection_v2/Screens/notifikasi_list.dart';
import 'package:fall_detection_v2/Screens/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user.dart';
class Gender {
  const Gender(this.key, this.label);

  final String key;
  final String label;
}
// Define a custom Form widget.
class DetailProfile extends StatefulWidget {
  @override
  DetailProfileState createState() {
    return DetailProfileState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class DetailProfileState extends State<DetailProfile> {
  late Future<User> futureDetailUser;
  var email;
  var password;
  var tb;
  var bb;
  var usia;
  var gender;
  var phone;
  var name;
  var alamat;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Gender> dataGender = <Gender>[
    const Gender('P', 'Perempuan'),
    const Gender('L', 'Laki-laki'),
  ];
  Gender findGender(String key) => dataGender.firstWhere((gender) => gender.key == key);
  late FirebaseMessaging messaging;

  void initState() {
    super.initState();
    futureDetailUser = AuthController().getProfile();
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
          title:Text('Profil', style: TextStyle(color: Colors.black, fontSize : 20),),
          elevation: 0,
          backgroundColor: Color(0xffffffff),
        ),
        extendBodyBehindAppBar: true,
        body:
        FutureBuilder<User>(
          future: futureDetailUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance
                  ?.addPostFrameCallback((timeStamp) {
                ///This schedules the callback to be executed in the next frame
                /// thus avoiding calling setState during build
                setState(() {
                  gender = snapshot.data!.gender;
                });
              });
              return SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 100, 20,20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              keyboardType: TextInputType.text,
                              initialValue: '${snapshot.data!.name}',
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
                                hintText: 'Nama Lengkap',
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field tidak boleh kosong';
                                }
                                setState(() {
                                  name = value;
                                });
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              initialValue: '${snapshot.data!.email}',
                              keyboardType: TextInputType.emailAddress,
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
                                hintText: 'E-Mail',
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field tidak boleh kosong';
                                }
                                setState(() {
                                  email = value;
                                });
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              initialValue: '${snapshot.data!.phone}',
                              keyboardType: TextInputType.number,
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
                                hintText: 'No. Telp',
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field tidak boleh kosong';
                                }
                                setState(() {
                                  phone = value;
                                });
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            Row(
                                children : [
                                  Expanded(
                                      child :TextFormField(
                                        initialValue: '${snapshot.data!.tb}',
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
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
                                          hintText: 'Tinggi badan',
                                        ),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Field tidak boleh kosong';
                                          }
                                          setState(() {
                                            tb = value;
                                          });
                                          return null;
                                        },
                                      )),
                                  SizedBox(width:5),
                                  Expanded(
                                      child :
                                      TextFormField(
                                        initialValue: '${snapshot.data!.bb}',
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
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
                                          hintText: 'Berat badan',
                                        ),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Field tidak boleh kosong';
                                          }
                                          setState(() {
                                            bb = value;
                                          });
                                          return null;
                                        },
                                      )),
                                ]
                            ),
                            const SizedBox(height: 15),
                            Row(
                                children : [
                                  Expanded(
                                    child :DropdownButtonFormField<Gender>(
                                      elevation: 16,
                                      value : findGender(snapshot.data!.gender),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
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
                                        hintText: 'Jenis Kelamin',
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (newValue != null) {
                                            gender = newValue.key;
                                          }
                                        });
                                      },
                                      items: dataGender.map((Gender gender) {
                                        return new DropdownMenuItem<Gender>(
                                          value: gender,
                                          child: new Text(
                                            gender.label,
                                            style: new TextStyle(color: Colors.black),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(width:5),
                                  Expanded(
                                      child : TextFormField(
                                        initialValue: '${snapshot.data!.usia}',
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
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
                                          hintText: 'Usia',
                                        ),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Field tidak boleh kosong';
                                          }
                                          setState(() {
                                            usia = value;
                                          });
                                          return null;
                                        },
                                      )),
                                ]
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              initialValue: '${snapshot.data!.alamat}',
                              keyboardType: TextInputType.text,
                              maxLines: 3,
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
                                hintText: 'Alamat',
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field tidak boleh kosong';
                                }
                                setState(() {
                                  alamat = value;
                                });
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
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
                      )));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const Center(child : CircularProgressIndicator());
          },
        )



    );
  }
  void _update() async{
    setState(() {
      _isLoading = true;
    });
    var  data = {
      'email' : email,
      'name' : name,
      'usia' : usia,
      'tb' : tb,
      'bb' : bb,
      'gender' : gender,
      'phone' : phone,
      'alamat' : alamat,
    };
    var res = await AuthController().postData(data, '/update');
    var body = json.decode(res.body);
    print(res.body);
    if(body['success']){
      Alert(
        context: context,
        type: AlertType.success,
        title: "Sukses update profil!",
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
