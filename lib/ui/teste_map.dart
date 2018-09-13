import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class TesteMap extends StatefulWidget {
  @override
  _TesteMapState createState() => _TesteMapState();
}

class _TesteMapState extends State<TesteMap> {

  Future<Map> dados;

  @override
  void initState() {
   dados = _getTempo().then((map) { });

  // print(dados.data['dias'][1]);

    super.initState();
  }

  Future<String> _loadCrosswordAsset() async {
    return await rootBundle.loadString('assets/data/previsaoTempo.json');
  }

  Future<Map> loadCrossword() async {
    print(await _loadCrosswordAsset());
    Map decoded = json.decode(await _loadCrosswordAsset());
    print(decoded['dias'][1]);
    print(decoded['dias'].runtimeType);
    return decoded;
  }


  Future<Map> _getTempo() async {
    http.Response response;
    response = await http.get("http://www.aerofilmes.com/previsaoTempo.json");
    //print(response.body);
    //print("esse print é verdade.");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }



}
