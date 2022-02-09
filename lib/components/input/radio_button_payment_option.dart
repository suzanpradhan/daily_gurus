import 'package:flutter/material.dart';

class RadioButtonPaymentOption extends StatelessWidget {
  final String name;
  final IconData icon;
  final int value;
  final int groupValue;
  final Function handleOnChanged;

  RadioButtonPaymentOption(
      {@required this.name,
      @required this.icon,
      @required this.value,
      @required this.groupValue,
      @required this.handleOnChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: (value) => this.handleOnChanged(value),
        ),
        Icon(icon),
        SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Text(name),
        )
      ],
    );
  }
}
