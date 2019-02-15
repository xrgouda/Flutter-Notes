import 'package:flutter/material.dart';


showSnackBar(String message, final scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: "UbuntuBold",
            fontSize: 17.0),
      ),
      backgroundColor: Colors.blue[800],
      duration: Duration(seconds: 4),
    ),
  );
}