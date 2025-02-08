import 'package:flutter/material.dart';
import 'package:model_app/welcome.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Welcome (),
    },
  ));
}