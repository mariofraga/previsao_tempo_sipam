import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class HomeTeste extends StatefulWidget {
  @override
  _HomeTesteState createState() => _HomeTesteState();
}

/*class Cidade {
  String nomeCidade;
  String uf;
  String estado;
  Cidade(this.nomeCidade, this.uf, this.estado);
}*/

class _HomeTesteState extends State<HomeTeste> {
  List<String> cidadesOrifinal = new List<String>();
  List<String> cidades = new List<String>();

  String _search;

  @override
  initState() {
    carregaCidadeLista();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Selecione a Cidade",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            onChanged:(text){
              setState(() {
                cidades = cidadesOrifinal.where((f) => f.toLowerCase().contains(text.toLowerCase())).toList();
                print("Quantidade de Cidades Encontradas: ${cidades.length.toString()}");
              });
            },
            decoration: InputDecoration(
              labelText: "Pesquise Aqui",
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: cidades.length,
            itemBuilder: (context, index) {
              return getCidadeList(context, index);
            },
          ),
        )
      ]),
    );
  }

  Future<Map> loadCrossword() async {
    Map decoded = json.decode(await _loadCrosswordAsset());
    return decoded;
  }

  void carregaCidadeLista() async {
    Map decoded = await loadCrossword();
    List<String> lc = new List();
    for (var cidade in decoded["estados"][6]["cidades"]) {
      cidades.add(cidade + " RO ");
      cidadesOrifinal.add(cidade + " RO ");
    }
    print("Quantidade de Cidades Encontradas: ${cidades.length.toString()}");
    setState(() {
      this.cidades = cidades;
    });
  }



  Future<String> _loadCrosswordAsset() async {
    return await rootBundle.loadString('assets/data/cidades.json');
  }

  Widget getCidadeList(BuildContext context, int index) {
    return Card(
        child: Container(
      padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(cidades[index]),
          FlatButton(
            onPressed: () {
              Navigator.pop(context, cidades[index]);
            },
            child: Icon(Icons.location_on),
          ),
        ],
      ),
    ));
  }
}
