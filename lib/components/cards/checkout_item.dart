import 'package:dailygurus/constants.dart';
import 'package:flutter/material.dart';

class CheckoutItem extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;

  CheckoutItem(
      {@required this.name, @required this.quantity, @required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Text(
                '${this.name}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: kColorDGrey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Qty: ${this.quantity.toString()}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: kColorDGrey,
                ),
              ),
            ),
            Text(
              '₹ ${this.price.toString()}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: kColorDGrey,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
          ],
        ),
        Divider(
          color: kColorLightGrey,
          thickness: 2.0,
        ),
      ],
    );
  }
}
