import 'package:dailygurus/components/scaffolds/fruits_background_scaffold.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsTestScreen extends StatefulWidget {
  @override
  _UserDetailsTestScreenState createState() => _UserDetailsTestScreenState();
}

class _UserDetailsTestScreenState extends State<UserDetailsTestScreen> {
  String _id, _name, _email, _phone;
  bool _loginStatus;

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final loginStatus = prefs.getBool('login_status');
    final id = prefs.getInt('id').toString();
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final phone = prefs.getString('phone');
    setState(() {
      _loginStatus = loginStatus;
      _id = id;
      _name = name;
      _email = email;
      _phone = phone;
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('login_status');
    prefs.remove('id');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('phone');
    Navigator.pushReplacementNamed(context, WELCOME_ROUTE);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FruitsBackgroundScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Login Status : ${_loginStatus.toString()}\nID: $_id\nEmail: $_email\nName: $_name\nPhone: $_phone',
              style: kProximaStyle.copyWith(
                color: kColorPureBlack,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: () {
                  logout();
                },
                color: kColorRed,
                textColor: kColorWhite,
                child: Text(
                  'LOGOUT',
                  style: kProximaStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
