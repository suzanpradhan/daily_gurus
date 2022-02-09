import 'dart:convert';

import 'package:dailygurus/constants/api_constants.dart';
import 'package:dailygurus/models/cart.dart';
import 'package:dailygurus/models/http_result.dart';
import 'package:dailygurus/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersProvider extends ChangeNotifier {
  List<OrderData> _orders;
  List<CartItem> _orderItems = [];

  final logger = Logger();

  set orders(List<OrderData> orders) {
    _orders = orders;
    notifyListeners();
  }

  List<OrderData> get orders => _orders;

  set orderItems(List<CartItem> orderItems) {
    _orderItems = orderItems;
    notifyListeners();
  }

  List<CartItem> get orderItems => _orderItems;

  Future<HTTPResult> getUserOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userID = prefs.getInt('id');

    http.Response response;

    try {
      response = await http.post(
        SHOW_ORDERS,
        body: jsonEncode(
          {'user_id': userID},
        ),
      );
    } catch (e) {
      print("ERROR");
      return HTTPResult(status: ERROR, message: 'An error Occurred');
    }

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "1") {
      final ordersJSON =
          jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      List<OrderData> userOrders = ordersJSON.map<OrderData>((json) {
        return OrderData.fromJson(json);
      }).toList();
      orders = userOrders;
      return HTTPResult(status: SUCCESS, message: 'Success');
    } else {
      return HTTPResult(
        status: ERROR,
        message: jsonDecode(response.body)['message'] ?? 'An Error Occurred',
      );
    }
  }

  Future<HTTPResult> getOrderDetails(int orderID) async {
    http.Response response;

    try {
      response = await http.post(
        GET_ORDER_DETAILS,
        body: jsonEncode(
          {'order_id': orderID},
        ),
      );
    } catch (e) {
      print("ERROR");
      return HTTPResult(status: ERROR, message: 'An error Occurred');
    }

    logger.i(response.body.toString());

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['status'].toString() == "1") {
      final itemsJSON =
          jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
      List<CartItem> items = itemsJSON.map<CartItem>((json) {
        return CartItem.fromJson(json);
      }).toList();
      _orderItems = items;
      return HTTPResult(status: SUCCESS, message: 'Success');
    } else {
      return HTTPResult(
        status: ERROR,
        message: jsonDecode(response.body)['message'] ?? 'An Error Occurred',
      );
    }
  }
}
