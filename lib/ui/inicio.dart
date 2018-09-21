import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:previsao_tempo/ui/cidades.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:previsao_tempo/ui/uteis.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}



class _InicioState extends State<Inicio> {

  var cidadeFavorita;
//  String no_municipio;
//  int co_municipio;
  Future<Map> dados;
  uteis s = new uteis();


  void _selecionaCidade(BuildContext c) async {
    final _recCidade = await Navigator.push(c, MaterialPageRoute(builder: (context) => Cidades()));
    if (_recCidade != null) {
      if (_recCidade != null) {
        cidadeFavorita = _recCidade;
        print("deu certo");
        s.writeData(cidadeFavorita.toString());
        print("gravou ok.");
      }
      setState(() {
        print(cidadeFavorita["co_municipio"]);
      });
    }
  }

  Future<Map> _getTempo(int co_municipio) async {
    http.Response response;
    response = await http.get("http://172.23.14.99:8000/api/previsao/ha45664Hk214g5f66l89u11gf/$co_municipio");
    String body = utf8.decode(response.bodyBytes);
    return json.decode(body);  }

  @override
  void initState() {
    inicioApp();
    super.initState();
  }


  Future<String> _loadCrosswordAsset() async {
    return await rootBundle.loadString('assets/data/favorito.json');
  }

  Future<Map> inicioApp() async {
    //Map decoded = json.decode(await _loadCrosswordAsset());
    Map decoded = json.decode(await s.readData());
    if(decoded["co_municipio"] == 0){
      _selecionaCidade(context);
    }
    return decoded;
  }



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


