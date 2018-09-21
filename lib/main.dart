import 'package:flutter/material.dart';
import 'package:previsao_tempo/ui/home.dart';
import 'package:previsao_tempo/ui/inicio.dart';
import 'ui/cidades.dart';
import 'ui/teste_map.dart';
import 'package:flutter/services.dart';
//import 'package:previsao_tempo/ui/teste_tabsdynamic.dart';
//import 'package:previsao_tempo/ui/teste2.dart';


void main() {
  runApp(MaterialApp(
    theme: ThemeData(
    ),
    home: Home(),
    debugShowCheckedModeBanner: false,
  )
  );
}
