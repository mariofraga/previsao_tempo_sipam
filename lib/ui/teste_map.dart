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



class EntidadeCidade{
  int co_municipio;
  String no_municipio;
  String no_sigla_uf;
}

class _TesteMapState extends State<TesteMap> {

  List<EntidadeCidade> cidadesOrifinal = new List<EntidadeCidade>();
  List<EntidadeCidade> cidades = new List<EntidadeCidade>();

  Future<Map> dados;

  @override
  void initState() {
    loadCrossword();
    carregaCidadeLista();
  // print(dados.data['dias'][1]);

    super.initState();
  }

  Future<String> _loadCrosswordAsset() async {
    return await rootBundle.loadString('assets/data/cidades_previsao.json');
  }

  Future<Map> loadCrossword() async {
    Map decoded = json.decode(await _loadCrosswordAsset());
      return decoded;
  }

  void carregaCidadeLista() async {
    Map decoded = await loadCrossword();
    List<String> lc = new List();
    EntidadeCidade c;
    for (var cidade in decoded["listaCidades"]) {
      c = new EntidadeCidade();
      c.no_municipio = cidade["no_municipio"];
      c.co_municipio = cidade["co_municipio"];
      c.no_sigla_uf = cidade["no_sigla_uf"];
      cidades.add(c);
    }
    print("Quantidade de Cidades Encontradas: ${cidades.length.toString()}");
    setState(() {
      this.cidades = cidades;
      this.cidadesOrifinal = cidades;
    });
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
