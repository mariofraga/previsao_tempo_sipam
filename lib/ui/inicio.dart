import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:previsao_tempo/ui/cidades.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}



class _InicioState extends State<Inicio> {

  var cidadeFavorita;
  String no_municipio;
  int co_municipio;
  Future<Map> dados;


  void _selecionaCidade(BuildContext c) async {
    final _recCidade = await Navigator.push(
        c, MaterialPageRoute(builder: (context) => Cidades()));
    if (_recCidade != null) {
      if (_recCidade != null) {
        cidadeFavorita = _recCidade;
        print("deu certo");
        dados = _getTempo(cidadeFavorita["co_municipio"]).then((map) {});
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
    loadCrossword();
    super.initState();
  }


  Future<String> _loadCrosswordAsset() async {
    return await rootBundle.loadString('assets/data/favorito.json');
  }

  Future<Map> loadCrossword() async {
    Map decoded = json.decode(await _loadCrosswordAsset());
    if(decoded["co_municipoo"] == 0){
      _selecionaCidade(context);
    } else {
    }
    return decoded;
  }



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

