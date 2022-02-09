import 'package:dailygurus/constants.dart';
import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => Future.value(false),
          child: Dialog(
            backgroundColor: kColorWhite,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(width: 20.0),
                  Text(
                    '$message',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
