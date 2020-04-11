import 'package:flutter/material.dart';

/// this function returns the style for the textfeilds used across
/// the `SignIn` and `Register` pages.
textInputDecoration(String text) {
  return InputDecoration(
    labelText: text,
    labelStyle: TextStyle(color: Colors.brown),
    // fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.deepOrange),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.red[100]),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.red[100]),
    ),
  );
}
