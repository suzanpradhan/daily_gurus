import 'dart:convert';
import 'dart:io';

import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/models/complex.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //LOGIN
  Future<HTTPResult> login(String email, String password) async {
    final fcmToken = await _firebaseMessaging.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(fcmToken);
    final http.Response response = await http.post(
      GET_LOGIN,
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'fcm_token': fcmToken,
        },
      ),
    );

    if (response.statusCode == 200) {
      print("RESPONSE " + response.body.toString());
      final body = jsonDecode(response.body);

      if (body['status'] == 0 || body['data']['otp_verify'] == NOT_VERIFIED) {
        if (body['data'] != "" && body['data']['otp_verify'] == NOT_VERIFIED) {
          print("NOT VERIFIED");
          //OTP NOT VERIFIED
          prefs.setString('input_id', email);
          prefs.setString('input_password', password);
          final data = jsonEncode(
            {
              '$OTP_STATUS': NOT_VERIFIED.toString(),
              'id': body['data']['id'],
            },
          );
          print("DATA " + jsonDecode(data).toString());
          return HTTPResult(
              status: SUCCESS, message: body['message'], data: data);
        } else {
          print("ERROR");
          return HTTPResult(
              status: ERROR, message: body['message'] ?? response.reasonPhrase);
        }
      } else if (body['data']['otp_verify'] == VERIFIED) {
        print("VERIFIED");
        // OTP Verified and logged in
        final data = body['data'];
        prefs.setString('input_id', email);
        prefs.setString('input_password', password);
        prefs.setBool('login_status', true);
        prefs.setInt('id', data['id']);
        prefs.setString('name', data['first_name']);
        prefs.setString('email', data['email']);
        prefs.setString('phone', data['mobile']);
        return HTTPResult(
            status: SUCCESS,
            message: body['message'],
            data: jsonEncode({
              OTP_STATUS: VERIFIED,
            }));
      } else {
        print("ERROR");
        return HTTPResult(
            status: ERROR, message: body['message'] ?? response.reasonPhrase);
      }
    }
    print("RETURN");
    return HTTPResult(status: ERROR, message: 'An unknown error occurred');
  }
  // END OF LOGIN

  // VERIFY OTP
  Future<HTTPResult> verifyOTP(String userID, String otp) async {
    print('$userID $otp');
    final http.Response response = await http.post(
      GET_OTP_VERIFY,
      body: jsonEncode(
        {'user_id': userID, 'otp': otp},
      ),
    );

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 1) {
      final body = jsonDecode(response.body);
      print(body.toString());
      if (body['message'] == 'The number has been verified') {
        return HTTPResult(status: SUCCESS, message: body['message']);
      }
    } else {
      print(response.statusCode);
      print(jsonDecode(response.body));
      return HTTPResult(
        status: ERROR,
        message: jsonDecode(response.body)['message'] ?? response.reasonPhrase,
      );
    }
  }

  // RESEND OTP
  Future<HTTPResult> resendOTP(int id) async {
    final http.Response response = await http.post(GET_OTP_RESEND,
        body: jsonEncode(
          {
            'user_id': id.toString(),
          },
        ));

    print(response.body.toString());
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 1) {
      final body = jsonDecode(response.body);
      return HTTPResult(status: SUCCESS, message: body['message']);
    } else {
      return HTTPResult(status: ERROR, message: 'Error! Failed to send OTP.');
    }
  }

  Future<http.Response> forgotPassword(String email) async {
    final http.Response response = await http.post(
      GET_FORGOT_PASSWORD,
      body: jsonEncode(
        {'user_login_email': email},
      ),
    );

    return response;
  }

  //REGISTER
  Future<HTTPResult> register(String firstName, String email, String password,
      String mobile, int complexID) async {
    final payload = jsonEncode(
      {
        'first_name': firstName.toString().trim(),
        'email': email.toString().trim(),
        'password': password.toString().trim(),
        'mobile': mobile.toString().trim(),
        'complex_id': complexID.toString().trim()
      },
    );

    print(payload.toString());

    final http.Response response =
        await http.post(USER_REGISTRATION, body: payload, headers: {
      HttpHeaders.acceptHeader: '*/*',
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'] == 1) {
      final body = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('input_id', email);
      prefs.setString('input_password', password);
      prefs.setInt('id', body['data']['id']);
      return HTTPResult(
        status: SUCCESS,
        message: body['message'],
        data: jsonEncode({
          'otp_register_id': body['data']['id'],
        }),
      );
    } else {
      print('STATUS CODE ${response.reasonPhrase}');
      print(jsonDecode(response.body)['message']);
      final body = jsonDecode(response.body);
      return HTTPResult(
          status: ERROR, message: body['message'] ?? response.reasonPhrase);
    }
  }

  Future<List<Complex>> fetchComplexes() async {
    print('FETCHING COMPLEXES');

    var response = await http.post(SHOW_COMPLEX_DETAILS);

    if (response.statusCode == 200) {
      print(jsonDecode(response.body).toString());
      final items =
          jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      List<Complex> _complexes = items.map<Complex>((json) {
        return Complex.fromJson(json);
      }).toList();
      print(_complexes);
      return _complexes;
    } else {
      throw Exception('Failed to Load Internet');
    }
  }

  Future<HTTPResult> addComplex(String apartmentName, String address,
      String familyResiding, String city, String pinCode) async {
    print("Adding Complex");

    var response = await http.post(
      ADD_COMPLEX,
      body: jsonEncode(
        {
          'apartment_name': apartmentName,
          'address': address,
          'family_residing': familyResiding,
          'city': city,
          'pin_code': pinCode,
        },
      ),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == 1) {
        print("RESPONSE  " + body.toString());
        return HTTPResult(
            status: SUCCESS, message: body['message'], data: body['data']);
      } else if (body['status'] == 0) {
        return HTTPResult(
          status: ERROR,
          message:
              'There was an error while adding the complex. Please try again later',
        );
      }
    } else {
      return HTTPResult(
        status: ERROR,
        message: 'Unexpected error. Please try again',
      );
    }
  }
}
