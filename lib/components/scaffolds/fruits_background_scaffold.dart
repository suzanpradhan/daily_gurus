import 'package:flutter/material.dart';

class FruitsBackgroundScaffold extends StatelessWidget {
  final Widget child;

  FruitsBackgroundScaffold({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/background_fruits.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
