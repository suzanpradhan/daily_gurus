import 'package:dailygurus/components/cards/checkout_item.dart';
import 'package:dailygurus/components/dialogs/loading_dialog.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/models/product.dart';
import 'package:dailygurus/providers/shopping_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ShoppingProvider shoppingProvider =
        Provider.of<ShoppingProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: shoppingProvider.productsInCart.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      Product item = shoppingProvider.productsInCart[index];
                      return CheckoutItem(
                        name: item.name,
                        quantity: item.selectedQuantity,
                        price:
                            (item.b2BPrice * item.selectedQuantity).toDouble(),
                      );
                    },
                  ),
                ),
                SizedBox(height: 40.0),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: kColorLightGreen,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Text(
                        'Cart Total: ₹${shoppingProvider.cartTotal}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kColorWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        showLoadingDialog(context, 'Processing order.');
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String userID = prefs.getInt('id').toString();
                        HTTPResult result =
                            await shoppingProvider.addToCart(userID);
                        Toast.show(result.message, context);
                        if (result.status == SUCCESS) {
                          Navigator.of(context)
                              .pushReplacementNamed(PAYMENT_ROUTE);
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: kColorWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: kColorWhite,
                          ),
                        ],
                      ),
                    ),
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
