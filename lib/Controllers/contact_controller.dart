import 'package:fall_detection_v2/Models/history.dart';
import 'package:fall_detection_v2/Models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import 'package:fall_detection_v2/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/contact.dart';

class ContactController {
  // ignore: prefer_typing_uninitialized_variables
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token')!= null ? jsonDecode(localStorage.getString('token') ?? "") : null;
  }

  Future<List<ContactModel>> getContacts() async {
    var full_url = API_URL+'/contact/all';
    await _getToken();
    final res = await http.get( Uri.parse(full_url),
        headers: _setHeaders());
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      List data = json['data'];
      print(data);
      return data.map((contacts) => new ContactModel.fromJson(contacts)).toList();
    } else {
      print(res.body);
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<History>> getHistories() async {
    var full_url = API_URL+'/history/all';
    await _getToken();
    final res = await http.get( Uri.parse(full_url),
        headers: _setHeaders());
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      List data = json['data'];
      print(res.body);
      return data.map((histories) => new History.fromJson(histories)).toList();
    } else {
      print(res.body);
      throw Exception('Failed to fetch data');
    }
  }



  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };

}