import 'dart:convert';

import 'package:dailygurus/components/buttons/back_button.dart';
import 'package:dailygurus/components/buttons/rounded_button.dart';
import 'package:dailygurus/components/input/text_field.dart';
import 'package:dailygurus/components/scaffolds/fruits_background_scaffold.dart';
import 'package:dailygurus/constants.dart';
import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/constants/route_constants.dart';
import 'package:dailygurus/models/address.dart';
import 'package:dailygurus/models/auth.dart';
import 'package:dailygurus/models/complex.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/providers/auth_provider.dart';
import 'package:dailygurus/providers/shopping_provider.dart';
import 'package:dailygurus/screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registrationFormKey = GlobalKey<FormState>();
  Complex _currentComplex = null;
  String _currentComplexName = "Address";
  bool _hasAddressError = false, _isLoading = false, _wasSuccessful;
  String _addressErrorMessage;
  String _name, _email, _phone, _password, _address, _city, _pinCode;
  HTTPResult _httpResult;

  void setSelectedComplex(Complex selectedComplex) {
    print("SELECTED COMPLEX" + selectedComplex.id.toString());
    setState(() {
      _currentComplex = selectedComplex;
      _currentComplexName = selectedComplex.name;
    });
  }

  void register() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoading = true;
    });
    _httpResult = await Provider.of<AuthProvider>(context, listen: false)
        .register(_name, _email, _password, _phone, 17);
    if (_httpResult.status == SUCCESS) {
      final data = jsonDecode(_httpResult.data);
      Address address = Address(
        address: '$_address',
        city: _city.toString(),
        pinCode: int.parse(_pinCode.trim()),
        complexID: 1,
        userID: data['otp_register_id'],
      );
      HTTPResult result =
          await Provider.of<ShoppingProvider>(context, listen: false)
              .addAddress(address);
      if (result.status == SUCCESS) {
        setState(() {
          _isLoading = false;
          _wasSuccessful = true;
        });
        Future.delayed(Duration(seconds: 1), () {
          final AuthArguments arguments =
              ModalRoute.of(context).settings.arguments;
          Navigator.pushReplacementNamed(context, OTP_VERIFY_ROUTE,
              arguments: OTPArguments(
                userID: data['otp_register_id'].toString(),
                rootRoute: arguments.rootRoute,
              ));
        });
      } else {
        setState(() {
          _isLoading = false;
          _wasSuccessful = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _wasSuccessful = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FruitsBackgroundScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomBackButton(
              name: 'Register',
              iconPath: 'assets/icons/back_button.png',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  height: 100.0,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28.0, 12.0, 28.0, 28.0),
              child: Form(
                key: _registrationFormKey,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      hintText: 'Name',
                      imagePath: 'assets/icons/user_icon.png',
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'A name is required.';
                        } else if (!RegExp("^[a-zA-Z]+").hasMatch(value)) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _name = val;
                        });
                      },
                    ),
                    CustomTextField(
                      hintText: 'Email',
                      imagePath: 'assets/icons/email_icon.png',
                      keyboardType: TextInputType.emailAddress,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'An email is required.';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _email = val;
                        });
                      },
                    ),
                    CustomTextField(
                      hintText: 'Mobile Number',
                      imagePath: 'assets/icons/phone_call.png',
                      keyboardType: TextInputType.number,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'A phone number is required.';
                        } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                            .hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        _phone = val;
                      },
                    ),

                    // GOOGLE ADDRESS REMOVED - Will use order address only
                    // Container(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: <Widget>[
                    //           Padding(
                    //             padding: const EdgeInsets.only(
                    //               top: 8.0,
                    //               bottom: 8.0,
                    //             ),
                    //             child: Image.asset(
                    //               'assets/icons/address.png',
                    //               height: 28.0,
                    //               width: 44.0,
                    //             ),
                    //           ),
                    //           Expanded(
                    //             child: GestureDetector(
                    //               onTap: () async {
                    //                 Prediction p =
                    //                     await PlacesAutocomplete.show(
                    //                   context: context,
                    //                   apiKey: GOOGLE_MAPS_API_KEY,
                    //                   components: [
                    //                     Component(Component.country, 'in'),
                    //                   ],
                    //                   mode: Mode.overlay,
                    //                   language: 'en',
                    //                 );
                    //                 print(p);
                    //                 setState(() {
                    //                   _address = p.description;
                    //                 });
                    //                 print(_address);
                    //                 SharedPreferences prefs =
                    //                     await SharedPreferences.getInstance();
                    //                 prefs.setString(
                    //                     'address_name', p.description);
                    //               },
                    //               child: Row(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: <Widget>[
                    //                   Expanded(
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.all(8.0),
                    //                       child: Text(
                    //                         '${_address != null ? _address : 'Address'}',
                    //                         style: TextStyle(
                    //                           fontFamily: 'Proxima Nova',
                    //                           color: _address != null
                    //                               ? kColorBlack
                    //                               : kColorGrey,
                    //                           fontSize: 16.0,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Icon(
                    //                       Icons.arrow_drop_down,
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       _hasAddressError == true
                    //           ? Row(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: <Widget>[
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(
                    //                     left: 52.0,
                    //                     bottom: 8.0,
                    //                   ),
                    //                   child: Text(
                    //                     '$_addressErrorMessage',
                    //                     style: kProximaStyle.copyWith(
                    //                       color: kColorRed,
                    //                       fontSize: 14.0,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             )
                    //           : SizedBox(
                    //               height: 0,
                    //               width: 0,
                    //             ),
                    //       Divider(
                    //         height: 1.0,
                    //         thickness: 1.0,
                    //         color: kColorBlack,
                    //       ),
                    //       SizedBox(
                    //         height: 6.0,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    CustomTextField(
                      hintText: 'Password',
                      imagePath: 'assets/icons/password_icon.png',
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'A password is required';
                        } else if (value.length < 8) {
                          return 'The password is too short';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _password = val;
                        });
                      },
                      isPasswordField: true,
                    ),
                    CustomTextField(
                      hintText: 'Address',
                      maxlines: 5,
                      minlines: 2,
                      keyboardType: TextInputType.text,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _address = val;
                        });
                      },
                    ),
                    CustomTextField(
                      hintText: 'City',
                      keyboardType: TextInputType.text,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your City name';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _city = val;
                        });
                      },
                    ),
                    // CustomTextField(
                    //   hintText: 'Area',
                    //   keyboardType: TextInputType.text,
                    //   validatorFunction: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please enter your Area details';
                    //     }
                    //     return null;
                    //   },
                    //   onChanged: (String val) {
                    //     setState(() {
                    //       _address = val;
                    //     });
                    //   },
                    // ),
                    CustomTextField(
                      hintText: 'Zip Code',
                      keyboardType: TextInputType.number,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Zip Code';
                        }
                        if (value.length < 6 || value.length > 7) {
                          return 'Please enter a valid Zip Code';
                        }
                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          _pinCode = val;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 28.0,
                      ),
                      child: _isLoading == false
                          ? RoundedButton(
                              title: 'REGISTER',
                              textColor: kColorWhite,
                              backgroundColor: kColorWelcomeText,
                              onPressed: () {
                                register();
                              },
                            )
                          : CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _wasSuccessful == true
                          ? Text(
                              '${_httpResult.message}',
                              style: kProximaStyle.copyWith(
                                color: kColorWelcomeText,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : _wasSuccessful == false
                              ? Text(
                                  '${_httpResult.message}',
                                  style: kProximaStyle.copyWith(
                                      color: kColorRed,
                                      fontWeight: FontWeight.bold),
                                )
                              : SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
