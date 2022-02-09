import 'package:dailygurus/components/input/text_field.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/models/address.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showAddAddressDialog(BuildContext context, Function addAddress) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AddAddressDialog(
      addAddress: addAddress,
    ),
  );
}

class AddAddressDialog extends StatelessWidget {
  final Function addAddress;
  final _addressFormKey = GlobalKey<FormState>();
  // final flatNoController = TextEditingController();
  final addressController = TextEditingController();
  // final blockController = TextEditingController();
  // final areaController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();

  AddAddressDialog({this.addAddress});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    return Dialog(
      child: Form(
        key: _addressFormKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Enter address details below',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 30),
                CustomTextField(
                  hintText: 'Address',
                  maxlines: 99,
                  minlines: 2,
                  textEditingController: addressController,
                  keyboardType: TextInputType.text,
                  validatorFunction: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                // CustomTextField(
                //   hintText: 'Flat No.',
                //   imagePath: null,
                //   textEditingController: flatNoController,
                //   keyboardType: TextInputType.number,
                //   validatorFunction: (value) {
                //     if (value.isEmpty) {
                //       return 'Please enter your Flat no.';
                //     }
                //     return null;
                //   },
                // ),
                // CustomTextField(
                //   hintText: 'Block',
                //   imagePath: null,
                //   textEditingController: blockController,
                //   validatorFunction: (String value) {
                //     if (value.isEmpty) {
                //       return 'Please enter your Block details';
                //     }
                //     return null;
                //   },
                // ),
                // CustomTextField(
                //   hintText: 'Area',
                //   imagePath: null,
                //   textEditingController: areaController,
                //   validatorFunction: (String value) {
                //     if (value.isEmpty) {
                //       return 'Please enter your Area details';
                //     }
                //     return null;
                //   },
                // ),
                CustomTextField(
                  hintText: 'City',
                  imagePath: null,
                  textEditingController: cityController,
                  validatorFunction: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter your City name';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  hintText: 'Pin Code',
                  imagePath: null,
                  textEditingController: pinCodeController,
                  keyboardType: TextInputType.number,
                  validatorFunction: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter your Pin Code';
                    }
                    if (value.length < 6 || value.length > 7) {
                      return 'Please enter a valid Pin Code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.0),
                RaisedButton(
                  onPressed: () async {
                    if (_addressFormKey.currentState.validate()) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      logger.i(
                          'Address : ${addressController.value.text}\nCity: ${cityController.value.text}\nPin Code: ${pinCodeController.value.text}');
                      Address address = Address(
                        address: '${addressController.value.text}',
                        city: cityController.value.text,
                        pinCode: int.parse(pinCodeController.value.text.trim()),
                        complexID: 1,
                        userID: prefs.getInt('id'),
                      );
                      this.addAddress(address);
                      Navigator.of(context, rootNavigator: true).pop();
                      return;
                    } else {
                      return;
                    }
                  },
                  textColor: kColorWhite,
                  color: kColorLightGreen,
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Text('Add Address'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
