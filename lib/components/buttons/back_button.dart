import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final String name;
  final String iconPath;
  final Function onTap;

  CustomBackButton({
    @required this.name,
    @required this.iconPath,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(iconPath),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Proxima Nova',
                fontSize: 20.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
