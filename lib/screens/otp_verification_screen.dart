import 'dart:convert';

import 'package:dailygurus/components/buttons/rounded_button.dart';
import 'package:dailygurus/components/scaffolds/fruits_background_scaffold.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPArguments {
  final String userID;
  final String rootRoute;

  OTPArguments({
    this.userID,
    this.rootRoute,
  });
}

class OTPVerificationScreen extends StatefulWidget {
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String _otpValue;
  bool _isOTPInvalid = false;
  bool _isLoading = false, _wasSuccessful;
  String _resultMessage;

  void verifyOTPandLogin(String userID) async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    HTTPResult otpResult =
        await Provider.of<AuthProvider>(context, listen: false)
            .verifyOTP(userID, _otpValue);

    if (otpResult.status == ERROR) {
      setState(() {
        _isLoading = false;
        _wasSuccessful = false;
        _resultMessage = otpResult.message;
      });
    } else if (otpResult.status == SUCCESS) {
      final inputEmail = prefs.getString('input_id');
      final inputPassword = prefs.getString('input_password');
      final loginResult =
          await Provider.of<AuthProvider>(context, listen: false)
              .login(inputEmail, inputPassword);
      final data = jsonDecode(loginResult.data) ?? null;
      print(data);
      if (loginResult.status == SUCCESS && data[OTP_STATUS] == VERIFIED) {
        setState(() {
          _isLoading = false;
          _wasSuccessful = true;
          _resultMessage = 'Login Successful';
        });
        final OTPArguments args = ModalRoute.of(context).settings.arguments;
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, args.rootRoute);
        });
      } else {
        setState(() {
          _isLoading = false;
          _wasSuccessful = false;
          _resultMessage = loginResult.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final OTPArguments args = ModalRoute.of(context).settings.arguments;
    return FruitsBackgroundScaffold(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/logo.png',
            height: 120.0,
          ),
          Text(
            'Enter OTP',
            style: kProximaStyle.copyWith(
              fontSize: 26.0,
              color: kColorGrey,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'We have sent you an access code',
            style: kProximaStyle.copyWith(
              fontSize: 20.0,
              color: kColorGrey,
            ),
          ),
          Text(
            'via SMS for mobile number verification',
            style: kProximaStyle.copyWith(
              fontSize: 20.0,
              color: kColorGrey,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              onChanged: (value) {
                print(value);
                setState(() {
                  _otpValue = value;
                });
              },
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                activeColor: kColorGreen,
                inactiveColor: kColorGrey,
                selectedColor: kColorGreen,
              ),
              backgroundColor: Colors.transparent,
              enableActiveFill: false,
            ),
          ),
          _isOTPInvalid == true
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                  ),
                  child: Text(
                    'Please enter a valid OTP.',
                    style: kProximaStyle.copyWith(
                        color: kColorRed, fontWeight: FontWeight.bold),
                  ),
                )
              : SizedBox(
                  height: 12.0,
                ),
          _isLoading == false
              ? RoundedButton(
                  title: 'LOGIN',
                  onPressed: () {
                    if (_otpValue.length == 4) {
                      setState(() {
                        _isOTPInvalid = false;
                      });
                      verifyOTPandLogin(args.userID);
                    } else {
                      setState(() {
                        _isOTPInvalid = true;
                      });
                    }
                  },
                  textColor: kColorWhite,
                )
              : CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _wasSuccessful == true
                ? Text(
                    '$_resultMessage',
                    style: kProximaStyle.copyWith(
                      color: kColorWelcomeText,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : _wasSuccessful == false
                    ? Text(
                        '$_resultMessage',
                        style: kProximaStyle.copyWith(
                            color: kColorRed, fontWeight: FontWeight.bold),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
          )
        ],
      ),
    );
  }
}
