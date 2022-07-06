
import 'package:fall_detection_v2/Widgets/accordion.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:fall_detection_v2/Screens/notifikasi_list.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    // TODO: implement initState
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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.lightBlue, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title:Text('FAQ (Bantuan)', style: TextStyle(color: Colors.black, fontSize : 20),),
          elevation: 0,
          backgroundColor: Color(0xffffffff),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
              Accordion('Cara kerja deteksi jatuh?',
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam bibendum ornare vulputate. Curabitur faucibus condimentum purus quis tristique.',
                Icon(Icons.person,
                    color: Colors.indigo),),
              Accordion('Cara tambah kontak',
                'Fusce ex mi, commodo ut bibendum sit amet, faucibus ac felis. Nullam vel accumsan turpis, quis pretium ipsum. Pellentesque tristique, diam at congue viverra, neque dolor suscipit justo, vitae elementum leo sem vel ipsum',
                Icon(Icons.list,
                    color: Colors.indigo),),
              Accordion('Cara menghapus kontak',
                'Nulla facilisi. Donec a bibendum metus. Fusce tristique ex lacus, ac finibus quam semper eu. Ut maximus, enim eu ornare fringilla, metus neque luctus est, rutrum accumsan nibh ipsum in erat. Morbi tristique accumsan odio quis luctus.',
                Icon(Icons.delete,
                    color: Colors.indigo),),
              Accordion('Tanda ketika jatuh',
                'Nulla facilisi. Donec a bibendum metus. Fusce tristique ex lacus, ac finibus quam semper eu. Ut maximus, enim eu ornare fringilla, metus neque luctus est, rutrum accumsan nibh ipsum in erat. Morbi tristique accumsan odio quis luctus.',
                Icon(Icons.warning,
                    color: Colors.indigo),),
            ])
        )
    );
  }
}
