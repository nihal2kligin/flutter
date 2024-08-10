import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, ToastGravity gravity, Color backgroundColor, Color textColor) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
  );
}

void toast_warning(String message) {
  showToast(
    message,
    ToastGravity.BOTTOM,
    Colors.orange,  // Customize as needed
    Colors.white,
  );
}

void toast_error(String message) {
  showToast(
    message,
    ToastGravity.BOTTOM,
    Colors.red,
    Colors.white,
  );
}

void toast_success(String message) {
  showToast(
    message,
    ToastGravity.BOTTOM,
    Colors.green,
    Colors.white,
  );
}

void toast_info(String message) {
  showToast(
    message,
    ToastGravity.BOTTOM,
    Colors.blue,
    Colors.white,
  );
}
