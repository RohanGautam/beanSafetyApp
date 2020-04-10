import 'package:flutter/material.dart';

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
