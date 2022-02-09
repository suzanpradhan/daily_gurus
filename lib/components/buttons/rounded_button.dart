import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Function onPressed;
  final BorderSide borderSide;

  RoundedButton({
    @required this.title,
    @required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 28.0, right: 28.0, top: 10.0, bottom: 10.0),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width - 56.0,
        height: 52.0,
        child: RaisedButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: borderSide ??
                BorderSide(
                  color: Colors.transparent,
                  width: 0.0,
                ),
          ),
          color: backgroundColor,
          elevation: 0,
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
