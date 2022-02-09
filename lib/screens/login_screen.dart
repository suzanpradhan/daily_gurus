import 'dart:convert';

import 'package:dailygurus/components/buttons/back_button.dart';
import 'package:dailygurus/components/buttons/rounded_button.dart';
import 'package:dailygurus/components/dialogs/forgot_password_dialog.dart';
import 'package:dailygurus/components/input/text_field.dart';
import 'package:dailygurus/components/scaffolds/fruits_background_scaffold.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/models/auth.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/providers/auth_provider.dart';
import 'package:dailygurus/screens/otp_verification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _isLoading = false;
  bool _wasSuccessful = false;
  HTTPResult _loginResult;
  String _resultMessage = '';

  void login() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    _loginResult = await Provider.of<AuthProvider>(context, listen: false)
        .login(_email, _password);
    print(_loginResult.data.toString());
    if (_loginResult.status == SUCCESS &&
        jsonDecode(_loginResult.data)[OTP_STATUS] == NOT_VERIFIED) {
      HTTPResult otpResendResult =
          await Provider.of<AuthProvider>(context, listen: false)
              .resendOTP(jsonDecode(_loginResult.data)['id']);
      if (otpResendResult.status == SUCCESS) {
        // OTP SEND SUCCESS
        print('OTP SEND SUCCESS');
        setState(() {
          _isLoading = false;
          _wasSuccessful = true;
          _resultMessage = 'Please verify the OTP that you have received';
        });
        Future.delayed(Duration(seconds: 1), () {
          final AuthArguments arguments =
              ModalRoute.of(context).settings.arguments;
          Navigator.pushReplacementNamed(context, OTP_VERIFY_ROUTE,
              arguments: OTPArguments(
                userID: jsonDecode(_loginResult.data)['id'].toString(),
                rootRoute: arguments.rootRoute,
              ));
        });
      } else {
        setState(() {
          _isLoading = false;
          _wasSuccessful = false;
          _resultMessage = otpResendResult.message;
        });
      }
    } else if (_loginResult.status == SUCCESS &&
        jsonDecode(_loginResult.data)[OTP_STATUS] == VERIFIED) {
      setState(() {
        _isLoading = false;
        _wasSuccessful = true;
        _resultMessage = 'Login Successful';
      });
      Future.delayed(Duration(milliseconds: 500), () {
        final AuthArguments arguments =
            ModalRoute.of(context).settings.arguments;
        Navigator.pushReplacementNamed(context, arguments.rootRoute);
      });
    } else {
      var logger = Logger();
      logger.d(_loginResult);
      setState(() {
        _isLoading = false;
        _wasSuccessful = false;
        _resultMessage = _loginResult.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthArguments arguments = ModalRoute.of(context).settings.arguments;
    return FruitsBackgroundScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomBackButton(
              name: 'Login',
              iconPath: 'assets/icons/back_button.png',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  height: 140.0,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28.0, 12.0, 28.0, 28.0),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      hintText: 'Email/Mobile Number',
                      imagePath: 'assets/icons/email_icon.png',
                      keyboardType: TextInputType.emailAddress,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'An email is required.';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Please enter a valid email.';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        setState(() {
                          _email = value.trim();
                        });
                      },
                    ),
                    CustomTextField(
                      hintText: 'Password',
                      imagePath: 'assets/icons/password_icon.png',
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'A password is required.';
                        } else if (value.length < 6) {
                          return 'The password is too short';
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        setState(() {
                          _password = value.trim();
                        });
                      },
                      isPasswordField: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              showForgotPasswordDialog(context);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: kProximaStyle.copyWith(
                                color: kColorGrey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: _isLoading == false
                          ? Column(
                              children: <Widget>[
                                RoundedButton(
                                  title: 'SIGN IN',
                                  backgroundColor: kColorWelcomeText,
                                  textColor: kColorWhite,
                                  onPressed: () {
                                    if (_loginFormKey.currentState.validate()) {
                                      login();
                                    } else {
                                      return;
                                    }
                                  },
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'OR',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: kColorGrey,
                                    fontFamily: 'Proxima Nova',
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                RoundedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      REGISTER_ROUTE,
                                      arguments: AuthArguments(
                                        rootRoute: arguments.rootRoute,
                                      ),
                                    );
                                  },
                                  title: 'CREATE AN ACCOUNT',
                                  backgroundColor: kColorWhite,
                                  textColor: kColorGrey,
                                  borderSide: BorderSide(
                                    color: kColorGrey,
                                    width: 1.0,
                                  ),
                                )
                              ],
                            )
                          : CircularProgressIndicator(),
                    ),
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
                                      color: kColorRed,
                                      fontWeight: FontWeight.bold),
                                )
                              : SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
