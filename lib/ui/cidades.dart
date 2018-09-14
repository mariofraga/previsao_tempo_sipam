import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class Cidades extends StatefulWidget {
  @override
  _CidadesState createState() => _CidadesState();
}

/*class Cidade {
  String nomeCidade;
  String uf;
  String estado;
  Cidade(this.nomeCidade, this.uf, this.estado);
}*/

class _CidadesState extends State<Cidades> {
  List<String> cidadesOrifinal = new List<String>();
  List<String> cidades = new List<String>();

  String _search;

  @override
  initState() {
    carregaCidadeLista();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[900],
          title: Text(
            "Selecione a Cidade",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("images/sol1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                onChanged: (text) {
                  setState(() {
                    cidades = cidadesOrifinal
                        .where(
                            (f) => f.toLowerCase().contains(text.toLowerCase()))
                        .toList();
                    print(
                        "Quantidade de Cidades Encontradas: ${cidades.length.toString()}");
                  });
                },
                decoration: InputDecoration(
                  labelText: "Pesquise Aqui",
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Container(
              child: FutureBuilder(
                  future: loadCrossword(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case (ConnectionState.waiting):
                      case (ConnectionState.none):
                        return Container(
                          width: 120.0,
                          height: 120.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError)
                          return Container();
                        else
                          return carregarLista(context, snapshot);
                    }
                  }),
            )
          ]),
        ));
  }

  Widget carregarLista(BuildContext context, AsyncSnapshot snapshot) {
    return Expanded(
        child: Container(
      color: Colors.black38,
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: cidades.length,
        itemBuilder: (context, index) {
          return getCidadeList(context, index);
        },
      ),
    ));
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
    return Container(
        padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
        color: Colors.black12,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, cidades[index]);
                  },
                  child:

                Text(cidades[index],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                ),


                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, cidades[index]);
                  },
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            new Divider(
              height: 5.0,
              color: Colors.white,
            )
          ],
        ));
  }
}
