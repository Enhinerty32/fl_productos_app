import 'package:flutter/material.dart';

class NotificationsServices {
  static late GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static showSnackbar(String mensaje) {
    final snackBar = SnackBar(
        content: Text(
      mensaje,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ));
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
