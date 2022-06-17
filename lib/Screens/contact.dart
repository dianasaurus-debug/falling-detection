import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:fall_detection_v2/Controllers/contact_controller.dart';
import 'package:fall_detection_v2/Models/contact.dart';
import 'package:fall_detection_v2/Widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fall_detection_v2/controllers/auth_controller.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact>? contacts;
  late Future<List<ContactModel>> futureListContact;
  final _formKey = GlobalKey<FormState>();

  bool isAuth = false;
  var phone;
  var name;
  var role;
  var _isLoading = false;
  var user = null;

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var user_storage = localStorage.getString('user');
    if (token != null && user_storage != null) {
      setState(() {
        isAuth = true;
        user = jsonDecode(user_storage);
      });
    }
  }

  Future<List<ContactModel>> _refreshContacts(BuildContext context) async {
    futureListContact =
        ContactController().getContacts() as Future<List<ContactModel>>;
    return futureListContact;
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      List<Contact> sample_contacts = await ContactsService.getContacts();
      setState(() {
        contacts = sample_contacts;
      });
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _askPermissions();
    _checkIfLoggedIn();
    futureListContact =
        ContactController().getContacts() as Future<List<ContactModel>>;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Se
        backgroundColor: Colors.white, // t this height
        title: Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Daftar Kontak',
            style: TextStyle(color: Colors.black),
          ),
          Text(
            'Tekan tambah untuk menambahkan kontak\nyang dihubungi saat jatuh',
            style: TextStyle(color: Colors.blueGrey, fontSize: 12),
          ),
        ])),
        iconTheme: IconThemeData(
          color: Color(0xff80cbc4), //change your color here
        ),
      ),
      body: isAuth == true
          ? RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.white,
              onRefresh: () => _refreshContacts(context),
              child: Stack(
                children: [
                  ListView(),
                  FutureBuilder<List<ContactModel>>(
                    future: futureListContact,
                    builder: (context, contactData) {
                      if (contactData.hasData) {
                        if (contacts != null) {
                          if (contacts!.length > 0) {
                            return ListView.builder(
                                itemCount: contacts!.length,
                                itemBuilder: (context, index) {
                                  Contact contact = contacts![index];
                                  return Card(
                                    child: ListTile(
                                        leading: (contact.avatar != null &&
                                                contact.avatar!.length > 0)
                                            ? CircleAvatar(
                                                backgroundImage: MemoryImage(
                                                    contact.avatar!))
                                            : CircleAvatar(
                                                child:
                                                    Text(contact.initials())),
                                        title: Text("${contact.displayName}"),
                                        subtitle: Text(
                                            (contact.phones!.length > 0)
                                                ? "${contact.phones![0].value}"
                                                : "Tidak ada data kontak"),
                                                trailing: contactData.data!
                                                    .firstWhere(
                                                        (item) =>
                                                            item.phone ==
                                                                (contact.phones!.length > 0
                                                                ? "${contact.phones![0].value}"
                                                                : ""),
                                                        orElse: () =>
                                                            ContactModel(
                                                                0, '', '', ''))
                                                    .id ==
                                                0
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  addContactDialog(contact);
                                                },
                                                child: const Text('Tambah'))
                                            : ElevatedButton(
                                                onPressed: () {
                                                  ContactModel contactDetail = contactData.data!.firstWhere((item) => item.phone == contact.phones![0].value, orElse: () => ContactModel(0, 'Unknown', 'Unknown', 'Unknown'));
                                                  detailContact(contactDetail);
                                                },
                                                child: const Text('Detail'))),
                                  );
                                });
                          } else {
                            return Center(
                                child: Text('Tidak ada kontak ditemukan'));
                          }
                        } else {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  backgroundColor: Colors.red,
                                ),
                                Text("\nMembaca Kontak...")
                              ],
                            ),
                          );
                        }
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
                ],
              ))
          : contacts != null
              ? (contacts!.length > 0
                  ? ListView.builder(
                      itemCount: contacts!.length,
                      itemBuilder: (context, index) {
                        Contact contact = contacts![index];
                        return Card(
                          child: ListTile(
                            leading: (contact.avatar != null &&
                                    contact.avatar!.length > 0)
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar!))
                                : CircleAvatar(child: Text(contact.initials())),
                            title: Text("${contact.displayName}"),
                            subtitle: Text((contact.phones!.length > 0)
                                ? "${contact.phones![0].value}"
                                : "Tidak ada data kontak"),
                          ),
                        );
                      })
                  : Center(child: Text('Tidak ada kontak ditemukan')))
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                      Text("\nMembaca Kontak...")
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavbar(current: 2),
    );
  }

  void addContact() async {
    _isLoading = true;
    var data = {'name': name, 'phone': phone, 'role': role};
    print(data);
    var res = await AuthController().postData(data, '/contact/create');
    var body = json.decode(res.body);
    print(body);
    if (body['success'] == true) {
      _isLoading = false;
      Alert(
        context: context,
        type: AlertType.success,
        title: "Berhasil menambahkan kontak!",
        buttons: [
          DialogButton(
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => ContactPage()),
            ),
            width: 120,
          )
        ],
      ).show();
    } else {
      _isLoading = false;
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal menambahkan kontak!",
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
  }

  void addContactDialog(Contact contact) {
    Alert(
      context: context,
      title: "Kontak Darurat",
      content: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: contact.displayName,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'Nama',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  setState(() {
                    name = value;
                  });
                  return null;
                },
              ),
              TextFormField(
                initialValue: contact.phones![0].value,
                enabled: false,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'Nomor Handphone',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Peran tidak boleh kosong';
                  }
                  setState(() {
                    phone = value;
                  });
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 12),
                  labelText: 'Peran (Ayah/Teman/Mama/dll)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Peran tidak boleh kosong';
                  }
                  setState(() {
                    role = value;
                  });
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    addContact();
                  }
                },
                child: Text(
                  _isLoading ? 'Loading...' : 'Simpan',
                ),
              )
            ],
          )),
      buttons: [],
    ).show();
  }

  void detailContact(ContactModel contact) {
    Alert(
      context: context,
      title: "Detail Kontak",
      content: Column(
        children: <Widget>[
          Row(children: [
            Text('Nama : ', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${contact.name}')
          ]),
          Row(children: [
            Text('Nomor HP : ', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${contact.phone}')
          ]),
          Row(children: [
            Text('Peran : ', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${contact.role}')
          ]),
        ],
      ),
      buttons: [],
    ).show();
  }
}
