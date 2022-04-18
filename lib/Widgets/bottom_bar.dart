import 'package:fall_detection_v2/Screens/beranda.dart';
import 'package:fall_detection_v2/Screens/contact.dart';
import 'package:fall_detection_v2/Screens/notifikasi_list.dart';
import 'package:fall_detection_v2/Screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomNavbar extends StatelessWidget {
  final int current;
  BottomNavbar({Key? key, required this.current}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      currentIndex: current,
      onTap: (value) {
        switch (value) {
          case 0:
            Route route = MaterialPageRoute(
                builder: (context) => Beranda());
            Navigator.push(context, route);
            break;
          case 1:
            Route route = MaterialPageRoute(
                builder: (context) => NotifikasiPage());
            Navigator.push(context, route);
            break;
          case 2:
            Route route = MaterialPageRoute(
                builder: (context) => ContactPage());
            Navigator.push(context, route);
            break;
          case 3:
            Route route = MaterialPageRoute(
                builder: (context) => ProfilePage());
            Navigator.push(context, route);
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.black),
          label: 'Beranda',
          backgroundColor: Colors.grey,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications, color: Colors.black),
          label: 'Notifikasi',
          backgroundColor: Colors.grey,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contact_phone, color: Colors.black),
          label: 'Kontak',
          backgroundColor: Colors.grey,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.black),
          label: 'Profil',
          backgroundColor: Colors.grey,
        ),
      ],
    );
  }
}