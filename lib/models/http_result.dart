import 'package:flutter/material.dart';

class HTTPResult {
  final String status;
  final String message;
  final Object data;

  HTTPResult({@required this.status, @required this.message, this.data});
}
