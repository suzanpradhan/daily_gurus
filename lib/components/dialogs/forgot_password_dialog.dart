import 'dart:convert';

import 'package:dailygurus/constants.dart';
import 'package:dailygurus/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void showForgotPasswordDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) => ForgotPasswordDialogBuilder());
}

class ForgotPasswordDialogBuilder extends StatefulWidget {
  @override
  _ForgotPasswordDialogBuilderState createState() =>
      _ForgotPasswordDialogBuilderState();
}

class _ForgotPasswordDialogBuilderState
    extends State<ForgotPasswordDialogBuilder> {
  String _resetEmail;
  bool _isProcessingRequest = false;
  bool _hasProcessedRequest = false;
  String _statusMessage;

  void closeDialogAfterTimeout(context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  void sendPasswordResetRequest() async {
    setState(() {
      _isProcessingRequest = true;
    });
    final http.Response response =
        await Provider.of<AuthProvider>(context, listen: false)
            .forgotPassword(_resetEmail);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == "SUCCESS") {
        setState(() {
          _hasProcessedRequest = true;
          _statusMessage = "Password reset mail sent successfully.";
        });
      } else {}
    }
  }

  final _forgotPasswordFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (!_isProcessingRequest && !_hasProcessedRequest) {
      return Dialog(
        child: Container(
          padding:
              EdgeInsets.only(top: 12.0, left: 5.0, right: 5.0, bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Did you forget your password?',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Proxima Nova',
                  color: kColorBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Form(
                  key: _forgotPasswordFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28.0,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kColorGreen,
                                width: 1.0,
                              ),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 14.0,
                            ),
                            hintText: 'Enter your registered email here',
                            hintStyle: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 16.0,
                              color: kColorGrey,
                            ),
                          ),
                          validator: (value) {
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
                            _resetEmail = value;
                          },
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: kColorGreen,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                if (_forgotPasswordFormKey.currentState
                                    .validate()) {
                                  sendPasswordResetRequest();
                                } else {
                                  return;
                                }
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                  color: kColorGreen,
                                  fontSize: 16.0,
                                ),
                              ),
                            )
                          ],
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
    } else if (_isProcessingRequest && !_hasProcessedRequest) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 25.0,
            horizontal: 10.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        kColorWelcomeText,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Sending password reset email.',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Proxima Nova',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (!_isProcessingRequest && _hasProcessedRequest) {
      closeDialogAfterTimeout(context);
      return Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 25.0,
            horizontal: 10.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  '$_statusMessage',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Proxima Nova',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return CircularProgressIndicator();
  }
}
