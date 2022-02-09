import 'package:dailygurus/components/input/text_field.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/models/address.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showEditAddressDialog(
    BuildContext context, Function editAddress, Address address) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AddAddressDialog(
      editAddress: editAddress,
      address: address,
    ),
  );
}

class AddAddressDialog extends StatefulWidget {
  final Function editAddress;
  final Address address;

  AddAddressDialog({
    this.editAddress,
    this.address,
  });

  @override
  _AddAddressDialogState createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _editAddressFormKey = GlobalKey<FormState>();

  final addressController = TextEditingController();

  final cityController = TextEditingController();

  final pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      addressController.text = widget.address.address;
      cityController.text = widget.address.city;
      pinCodeController.text = widget.address.pinCode.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    return Dialog(
      child: Form(
        key: _editAddressFormKey,
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
                  hintText: 'Flat No.',
                  imagePath: null,
                  textEditingController: addressController,
                  validatorFunction: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your Address.';
                    }
                    return null;
                  },
                ),
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
                    if (_editAddressFormKey.currentState.validate()) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      logger.i(
                          'Address: ${addressController.value.text}\nCity: ${cityController.value.text}\nPin Code: ${pinCodeController.value.text}');
                      Address address = Address(
                        address: '${addressController.value.text}',
                        city: cityController.value.text,
                        pinCode: int.parse(pinCodeController.value.text.trim()),
                        complexID: 1,
                        userID: prefs.getInt('id'),
                        id: widget.address.id,
                      );
                      this.widget.editAddress(address);
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
                      child: Text('Update Address'),
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
