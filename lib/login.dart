import 'dart:convert';

import 'package:fall_detection_v2/beranda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Define a custom Form widget.
class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return LoginState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class LoginState extends State<Login> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<LoginState>.
  var email;
  var password;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        backgroundColor: Color(0xff3551C6),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body:
            Container(
                constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "images/gradient_login.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Roboto',
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 25),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlueAccent, width: 2),
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
                                email = value;
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlueAccent, width: 2),
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
                                hintText: 'Password',
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field tidak boleh kosong';
                                }
                                password = value;
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // // Validate returns true if the form is valid, or false otherwise.
                                    // if (_formKey.currentState!.validate()) {
                                    //   // If the form is valid, display a snackbar. In the real world,
                                    //   // you'd often call a server or save the information in a database.
                                    // }
                                    Route route = MaterialPageRoute(
                                        builder: (context) => Beranda());
                                    Navigator.push(context, route);
                                  },
                                  style: styleLogin,
                                  child: Text(
                                    _isLoading ? 'Loading...' : 'Login',
                                  ),
                                )),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Belum punya akun? Register',
                                style: TextStyle(fontSize: 15, fontFamily: 'Roboto'),
                              ),
                            ),
                          ],
                        ),
                      ))))

    );
  }
}