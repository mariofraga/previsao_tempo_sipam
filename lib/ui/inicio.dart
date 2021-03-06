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
  Future<Map> dados;
  uteis u = new uteis();


  void _selecionaCidade(BuildContext c) async {
    final _recCidade = await Navigator.push(c, MaterialPageRoute(builder: (context) => Cidades()));
    if (_recCidade != null) {
      if (_recCidade != null) {
        cidadeFavorita = _recCidade;
        print("deu certo");
        print(_recCidade);
        u.writeData(json.encode(cidadeFavorita));
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
    Map decoded1 = json.decode(await _loadCrosswordAsset());
    Map decoded = await u.readData();

    print("teste inicio decoded -> ${decoded.toString()}");
    String body;
    if (decoded["co_municipio"] == 0) {
      _selecionaCidade(context);
   //   return decoded;
    }

    String urlCon;
    http.Response response;
    try {
      urlCon =      "http://www.aerofilmes.com/previsao_ok.json";
      // urlCon =      "http://172.23.14.99:8000/api/previsao/ha45664Hk214g5f66l89u11gf/${cidadeFavorita["co_municipio"]}";
      response = await http.get(urlCon);
      body = utf8.decode(response.bodyBytes);
    } catch(e){
      print("NÃ£o Conectou.");
      print(e.toString());
      urlCon =      "http://www.aerofilmes.com/previsao_ok.json";
      response = await http.get(urlCon);
      body = utf8.decode(response.bodyBytes);
    }

  }



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


