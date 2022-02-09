import 'package:dailygurus/components/buttons/back_button.dart';
import 'package:dailygurus/components/buttons/rounded_button.dart';
import 'package:dailygurus/components/input/text_field.dart';
import 'package:dailygurus/components/scaffolds/fruits_background_scaffold.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterComplexScreen extends StatefulWidget {
  @override
  _RegisterComplexScreenState createState() => _RegisterComplexScreenState();
}

class _RegisterComplexScreenState extends State<RegisterComplexScreen> {
  final _registerComplexFormKey = GlobalKey<FormState>();
  String _apartmentName, _address, _familyResiding, _city, _pinCode;
  bool _isLoading;
  HTTPResult _result;

  void addComplex() async {
    setState(() {
      _isLoading = true;
    });
    _result =
        await Provider.of<AuthProvider>(context, listen: false).addComplex(
      _apartmentName,
      _address,
      _familyResiding,
      _city,
      _pinCode,
    );

    if (_result.status == SUCCESS) {
      Future.delayed(
        Duration(seconds: 2),
        () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FruitsBackgroundScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CustomBackButton(
                  name: 'Register',
                  iconPath: 'assets/icons/back_button.png',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Image.asset(
              'assets/images/logo.png',
              height: 100.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0,
              ),
              child: Text(
                'Register your complex',
                style: kProximaStyle.copyWith(
                  fontSize: 20.0,
                ),
              ),
            ),
            Form(
              key: _registerComplexFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                ),
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      hintText: 'Apartment Name',
                      imagePath: null,
                      validatorFunction: (String value) {
                        if (value.isEmpty) {
                          return 'An apartment name is required.';
                        } else if (value.length < 4) {
                          return 'Please enter a valid apartment name.';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _apartmentName = val.trimRight();
                        });
                      },
                    ),
                    CustomTextField(
                      hintText: 'Address',
                      imagePath: null,
                      validatorFunction: (String value) {
                        if (value.isEmpty) {
                          return 'An address is required.';
                        } else if (value.length < 5) {
                          return 'Please enter a valid address.';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _address = val.trimRight();
                        });
                      },
                    ),
                    CustomTextField(
                      hintText: 'No. of family members residing',
                      imagePath: null,
                      keyboardType: TextInputType.number,
                      validatorFunction: (String value) {
                        if (value.isEmpty) {
                          return 'No. of family members is required.';
                        } else if (int.parse(value) < 0 ||
                            int.parse(value) > 15) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _familyResiding = val.trimRight();
                        });
                      },
                    ),
                    CustomTextField(
                      hintText: 'City',
                      imagePath: null,
                      validatorFunction: (String value) {
                        if (value.isEmpty) {
                          return 'A City name is required.';
                        } else if (value.length < 3) {
                          return 'Please enter a valid City name.';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _city = val.trimRight();
                        });
                      },
                    ),
                    CustomTextField(
                      hintText: 'Pincode',
                      imagePath: null,
                      keyboardType: TextInputType.number,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'A pin code is required.';
                        } else if (value.length < 5 || value.length > 8) {
                          return 'Please enter a valid pin code.';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _pinCode = val.trimRight();
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: _isLoading == true
                          ? CircularProgressIndicator()
                          : RoundedButton(
                              title: 'ADD COMPLEX',
                              onPressed: () {
                                if (!_registerComplexFormKey.currentState
                                    .validate()) {
                                  return;
                                } else {
                                  addComplex();
                                }
                              },
                              textColor: kColorWhite,
                            ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: _renderResultMessage()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderResultMessage() {
    if (_result != null && _result.status == SUCCESS) {
      Text(
        _result.message,
        style: kProximaStyle.copyWith(
          color: kColorGreen,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (_result != null && _result.status == ERROR) {
      return Text(
        _result.message,
        style: kProximaStyle.copyWith(
          color: kColorRed,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    return Text('');
  }
}
