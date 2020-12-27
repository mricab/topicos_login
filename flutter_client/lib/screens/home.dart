import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_client/screens/login.dart';
import 'package:flutter_client/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String fname;
  String lname;
  String address;
  String phone;
  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api App'),
        backgroundColor: Colors.cyan[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$fname $lname',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.pin_drop), Text('$address')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.phone), Text('$phone')],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {
                    logout();
                  },
                  color: Colors.blue[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        fname = user['fname'];
        lname = user['lname'];
        address = user['address'];
        phone = user['phone'];
      });
    }
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
