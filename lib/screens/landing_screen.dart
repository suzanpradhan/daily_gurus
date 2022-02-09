import 'package:dailygurus/components/buttons/rounded_button.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
              child: Text(
                'Welcome to Dailygurus',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(fontSize: 34.0),
                  color: kColorWelcomeText,
                ),
              ),
            ),
            Image.asset('assets/images/welcome_page_image.png'),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: Text(
                'Get Home Delivery',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    color: kColorBlack,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12.0),
              child: Text(
                'The whole grocery store at',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: kColorDGrey,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12.0),
              child: Text(
                'your fingertips',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: kColorDGrey,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      RoundedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, SHOPPING_ROUTE);
                        },
                        title: 'B2B',
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      ),
                      RoundedButton(
                        onPressed: () {},
                        title: 'B2C',
                        backgroundColor: kColorWhite,
                        textColor: kColorGrey,
                        borderSide: BorderSide(
                          color: kColorGrey,
                          width: 1.0,
                        ),
                      )
                    ],
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
