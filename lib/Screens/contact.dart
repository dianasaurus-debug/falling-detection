
import 'dart:io';
import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:fall_detection_v2/Widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact>? contacts;
  @override
  void initState() {
    // TODO: implement initState
    _askPermissions();
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Daftar Kontak',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Color(0xff80cbc4), //change your color here
        ),
      ),
      body: contacts!=null? (contacts!.length>0) ? ListView.builder(
          itemCount: contacts!.length,
          itemBuilder: (context,index){
            Contact contact=contacts![index];
            return Card(
              child: ListTile(
                leading: (contact.avatar != null && contact.avatar!.length > 0) ? CircleAvatar(backgroundImage: MemoryImage(contact.avatar!)) : CircleAvatar(child: Text(contact.initials())),
                  title: Text("${contact.displayName}"),
                  subtitle: Text((contact.phones!.length>0)?"${contact.phones![0].value}":"Tidak ada data kontak"),
                  // trailing:InkWell(child:  Icon(Icons.call,color: Colors.green,),onTap: (){
                  //   _makePhoneCall("tel:${contact.phones.length.gcd(0)}");
                  // },)
              ),
            );
          }) : Center(child: Text('Tidak ada kontak ditemukan'),) : Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(backgroundColor: Colors.red,),Text("\nMembaca Kontak...")],),),
      bottomNavigationBar: BottomNavbar(current : 2),
    );
  }


}
