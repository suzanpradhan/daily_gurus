import 'package:dailygurus/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigateWithDelay() async {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, SHOPPING_ROUTE);
    });
  }

  @override
  void initState() {
    super.initState();
    navigateWithDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 200.0,
          ),
        ),
      ),
    );
  }
}
