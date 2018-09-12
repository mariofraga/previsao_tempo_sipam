import 'package:flutter/material.dart';
import 'ui/home.dart';
import 'ui/cidades.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[800],
        accentColor: Colors.green[600],
    ),
    home: Home(),
  )
  );
}
