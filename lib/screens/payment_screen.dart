import 'dart:convert';
import 'package:dailygurus/components/dialogs/loading_dialog.dart';
import 'package:dailygurus/components/input/radio_button_payment_option.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/models/order.dart';
import 'package:dailygurus/models/payment_option.dart';
import 'package:dailygurus/providers/shopping_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentOption _selectedPaymentOption = paymentOptions[0];
  String _name, _address, _city;
  int _pinCode;
  int _radioValue = 0;
  bool _hasAddressSaved;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void getWalletDetails(PaymentOption value, int radioValue) async {
    showLoadingDialog(context, 'Getting Wallet Details');
    HTTPResult result =
        await Provider.of<ShoppingProvider>(context, listen: false)
            .fetchWalletInfo();
    if (result.status == ERROR) {
      Navigator.of(context, rootNavigator: true).pop();
      final snackbar = SnackBar(
        content: Text('${result.message}'),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else if (Provider.of<ShoppingProvider>(context).cartTotal >
        jsonDecode(result.data)['balance']) {
      Navigator.of(context, rootNavigator: true).pop();
      final snackbar = SnackBar(
        content: Text('Wallet Balance insufficient.'),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        _selectedPaymentOption = value;
        _radioValue = radioValue;
      });
    }
  }

  void _handlePaymentRadioButtons(int value) {
    print(value);
    final selectedOption = paymentOptions[value];

    if (selectedOption.paymentType == PAYMENT_OPTION_WALLET) {
      getWalletDetails(selectedOption, value);
      return;
    }
    setState(() {
      _selectedPaymentOption = selectedOption;
      _radioValue = value;
    });
  }

  void initOrder(double cartTotal) async {
    showLoadingDialog(context, 'Processing Your Order');
    if (_selectedPaymentOption == null) {
      final snackbar = SnackBar(
        content: Text('Please select a payment method.'),
      );
      Navigator.of(context, rootNavigator: true).pop();
      _scaffoldKey.currentState.showSnackBar(snackbar);
      return;
    }
    if (_hasAddressSaved == false) {
      final snackbar = SnackBar(
        content: Text('Please select a delivery address.'),
      );
      Navigator.of(context, rootNavigator: true).pop();
      _scaffoldKey.currentState.showSnackBar(snackbar);
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int id = prefs.getInt('id');
    final String email = prefs.getString('email');
    final String phone = prefs.getString('phone');
    final String addressID = prefs.getInt('address_id').toString();
    OrderDetails orderDetails = OrderDetails(
      userID: id,
      totalPrice: cartTotal,
      discount: 0,
      shippingMethod: null,
      couponID: 0,
      shippingAmount: 0,
      paymentMethod: _selectedPaymentOption.paymentType,
      addressID: addressID,
      cartID: null,
    );

    HTTPResult result =
        await Provider.of<ShoppingProvider>(context, listen: false)
            .initOrder(orderDetails);

    Navigator.of(context, rootNavigator: true).pop();
    if (result.status == ERROR) {
      final snackbar = SnackBar(
        content: Text('${result.message}'),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      final data = jsonDecode(result.data);
      if (data['payment_mode'] == PAYMENT_OPTION_CC) {
        prefs.setInt('order_id', data['order_id']);
        startRazorPayPayment(email, phone, data['grand_total'].toString());
      } else {
        Alert(
          context: context,
          title: "SUCCESS",
          desc: "Your order has been placed successfully...Thank you.",
          image: Image.asset("assets/images/tick.png"),
          buttons: [
            DialogButton(
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Provider.of<ShoppingProvider>(context, listen: false)
                    .clearCart();
                Navigator.of(context).pushReplacementNamed(SHOPPING_ROUTE);
              },
              width: 120,
            )
          ],
        ).show();
      }
    }
  }

  void startRazorPayPayment(
      String email, String phone, String grandTotal) async {
    final _razorpay = Razorpay();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final orderID = prefs.getInt('order_id');
    var options = {
      'key': RAZOR_PAY_PROD_API_KEY,
      'amount': double.parse(grandTotal) * 100,
      'name': 'Razorpay Corp',
      'currency': 'INR',
      'receipt': orderID,
      //'order_id': orderID,
      'description': 'Demoing Charges',
      'image': 'https://s3.amazonaws.com/rzp-mobile/images/rzp.png',
      'prefill': {'contact': phone, 'email': email},
      'notes': {'order_id': orderID, 'address': "note value"},
    };
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    print('${response.orderId}');
    showLoadingDialog(context, 'Please Wait');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final orderID = prefs.getInt('order_id').toString();
    final userID = prefs.getInt('id').toString();
    HTTPResult result =
        await Provider.of<ShoppingProvider>(context, listen: false)
            .paymentResponse(orderID, response.paymentId.toString(), userID);
    if (result.status == SUCCESS) {
      Navigator.of(context, rootNavigator: true).pop();
      Alert(
        context: context,
        title: "SUCCESS",
        desc: "Your order has been placed successfully...Thank you.",
        image: Image.asset("assets/images/tick.png"),
        buttons: [
          DialogButton(
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Provider.of<ShoppingProvider>(context, listen: false).clearCart();
              Navigator.of(context).pushReplacementNamed(SHOPPING_ROUTE);
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final snackbar = SnackBar(
        content: Text('Your order has not been placed.'),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    final snackbar = SnackBar(
      content: Text('${response.message.toString()}'),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    print("ERROR" + response.message.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("External Wallet " + response.walletName);
  }

  @override
  void initState() {
    super.initState();
    fetchAddressData();
  }

  void fetchAddressData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final address = prefs.getString('current_address') ?? null;
    if (address != null) {
      setState(() {
        _name = prefs.getString('name');
        _address = prefs.getString('current_address');
        _city = prefs.getString('current_city');
        _pinCode = prefs.getInt('pin_code');
        _hasAddressSaved = true;
      });
    } else {
      setState(() {
        _hasAddressSaved = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Confirm'),
            content: new Text(
                'Are you sure you want to return to the previous page?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingProvider shoppingProvider =
        Provider.of<ShoppingProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Payment'),
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
                      'Payment Summary',
                      style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _hasAddressSaved == true
                      ? Container(
                          width: double.infinity,
                          height: 100.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '$_name',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Room #$_address',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '$_city - $_pinCode',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Please select your address.',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: OutlineButton(
                      color: kColorLightGreen,
                      textColor: kColorLightGreen,
                      borderSide: BorderSide(
                        color: kColorLightGreen,
                        width: 2.0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(ADD_ADDRESS_ROUTE);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Change or Add Address'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: <Widget>[
                        RadioButtonPaymentOption(
                          name: paymentOptions[0].menuName,
                          icon: paymentOptions[0].icon,
                          value: 0,
                          groupValue: _radioValue,
                          handleOnChanged: _handlePaymentRadioButtons,
                        ),
                        RadioButtonPaymentOption(
                          name: paymentOptions[1].menuName,
                          icon: paymentOptions[1].icon,
                          value: 1,
                          groupValue: _radioValue,
                          handleOnChanged: _handlePaymentRadioButtons,
                        ),
                        RadioButtonPaymentOption(
                          name: paymentOptions[2].menuName,
                          icon: paymentOptions[2].icon,
                          value: 2,
                          groupValue: _radioValue,
                          handleOnChanged: _handlePaymentRadioButtons,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 20.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              'Total Price',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: kColorDGrey,
                              ),
                            ),
                          ),
                          Text(
                            '₹ ${shoppingProvider.cartTotalData?.isPrice ?? 0}',
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
                          'Order Total: ₹${(shoppingProvider.cartTotalData != null) ? shoppingProvider.cartTotalData.isPrice : ""}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: kColorWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          initOrder(shoppingProvider.cartTotalData.isPrice
                              .toDouble());
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
      ),
    );
  }
}
