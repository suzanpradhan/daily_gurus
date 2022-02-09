import 'package:dailygurus/components/dialogs/add_address_dialog.dart';
import 'package:dailygurus/components/dialogs/edit_address_dialog.dart';
import 'package:dailygurus/components/tabs/products_list_tab.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/models/address.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/providers/shopping_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  var logger = Logger();
  bool _isLoading = true;
  bool _hasError = false;
  List<Address> _addresses;

  void addAddress(Address address) async {
    HTTPResult result =
        await Provider.of<ShoppingProvider>(context, listen: false)
            .addAddress(address);
    if (result.status == SUCCESS) {
      Toast.show(result.message, context);
      fetchAddresses();
    } else {
      Toast.show(result.message, context);
      fetchAddresses();
    }
  }

  void fetchAddresses() async {
    List<Address> addresses =
        await Provider.of<ShoppingProvider>(context, listen: false)
            .fetchAddresses();
    logger.i(addresses.length);
    if (addresses != null) {
      setState(() {
        _addresses = addresses;
        _isLoading = false;
        _hasError = false;
      });
    } else {
      _isLoading = false;
      _hasError = true;
    }
  }

  void editAddress(Address updatedAddress) async {
    HTTPResult result =
        await Provider.of<ShoppingProvider>(context, listen: false)
            .editAddress(updatedAddress);
    if (result.status == SUCCESS) {
      setState(() {
        _isLoading = true;
      });
      fetchAddresses();
      Toast.show(result.message, context);
    } else {
      Toast.show(result.message, context);
    }
  }

  void addCurrentAddress(Address address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AlertDialog addAddressDialog = AlertDialog(
      title: Text('Add Current Address'),
      content: Text('Do you want to add this as your current address?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No'),
          textColor: kColorLightGreen,
        ),
        FlatButton(
          onPressed: () {
            prefs.setInt('address_id', address.id);
            prefs.setString('complex_name', address.complexName);
            prefs.setString('current_address', address.address);
            prefs.setString('current_city', address.city);
            prefs.setInt('pin_code', address.pinCode);
            Toast.show('Current Address Changed', context);
            Navigator.pushReplacementNamed(context, PAYMENT_ROUTE);
          },
          child: Text('Yes'),
          textColor: kColorLightGreen,
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addAddressDialog;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addresses'),
      ),
      body: Column(
        children: <Widget>[
          this._isLoading == false && this._hasError == false
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _addresses.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'ADDRESS ${index + 1}',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showEditAddressDialog(
                                          context,
                                          editAddress,
                                          _addresses[index],
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: kColorLightGreen),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${_addresses[index].address}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  '${_addresses[index].city} - ${_addresses[index].pinCode}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        addCurrentAddress(_addresses[index]);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          'Set as Current Address',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: kColorRed,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : this._isLoading == false && this._hasError == true
                  ? ErrorMessage(
                      retry: () {
                        setState(() {
                          _isLoading = true;
                        });
                        fetchAddresses();
                      },
                    )
                  : LoadingIndicator(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: OutlineButton(
              color: kColorLightGreen,
              textColor: kColorLightGreen,
              borderSide: BorderSide(
                color: kColorLightGreen,
                width: 2.0,
              ),
              onPressed: () {
                showAddAddressDialog(context, addAddress);
              },
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Add a New Address',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
