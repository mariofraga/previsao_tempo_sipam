import 'package:flutter/material.dart';
import 'package:previsao_tempo/ui/cidades.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String cidadeFavorita;
  int contadorfundo = 0;

  Future<Map> dados;

  @override
  void initState() {
    //listObjPrevisao;
    dados = _getTempo().then((map) {});

    super.initState();
    print("ok");
    if (cidadeFavorita == null || cidadeFavorita.isEmpty) {
      cidadeFavorita = "Porto Velho";
    } else {
      cidadeFavorita = "outra";
    }
  }

  Future<Map> _getTempo() async {
    http.Response response;
    response = await http.get("http://www.aerofilmes.com/previsaoTempo.json");
    return json.decode(response.body);
  }

  void _selecionaCidade(BuildContext c) async {
    final _recCidade = await Navigator.push(
        c, MaterialPageRoute(builder: (context) => Cidades()));
    if (_recCidade != null) {
      if (_recCidade != null) {
        cidadeFavorita = _recCidade;
      } else {
        cidadeFavorita = "nenhuma";
      }
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _getTempo(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
              case (ConnectionState.none):
                return Container(
                  width: 200.0,
                  height: 200.0,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 5.0,
                  ),
                );
              default:
                if (snapshot.hasError)
                  return Container();
                else
                  return DefaultTabController(
                    length: 3,
                    child:
                    Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.lightGreen[900],
                      centerTitle: true,
                      title: Text("Previsão do Tempo $cidadeFavorita",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold)),
                      bottom: TabBar(
                        labelColor: Colors.amber,
                        unselectedLabelColor: Colors.white,
                        tabs: [
                          Tab(
                            child: Text("HOJE"),
                          ),
                          Tab(
                            child: Text(snapshot.data["dias"][1]["diaSemana"]),
                          ),
                          Tab(
                            child: Text(snapshot.data["dias"][2]["diaSemana"]),
                          ),
                        ],
                      ),
                    ),
                    body: Container(
                      color: Colors.black38,
                      child: TabBarView(
                        children: [
                          pagePrevisaoTempo(snapshot, "01",
                              AlignmentDirectional.centerStart, 0),
                          pagePrevisaoTempo(snapshot, "01",
                              AlignmentDirectional.center, 0),
                          pagePrevisaoTempo(snapshot, "01",
                              AlignmentDirectional.centerEnd, 0),
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        _selecionaCidade(context);
                      },
                      backgroundColor: Colors.lightGreen[900],
                      tooltip: 'Inbox',
                      child: Icon(
                        Icons.location_on,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
               );
            }
          }),
    );
  }

  Widget pagePrevisaoTempo(AsyncSnapshot snapshot, String imgTemp,
      AlignmentDirectional alinhamento, int index) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.black38,
        image: new DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.hardLight),
          image: new AssetImage("images/sol2.jpg"),
          fit: BoxFit.cover,
          alignment: alinhamento,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          LinhaTemperatura(
              snapshot.data["dias"][index]["diaSemana"],
              snapshot.data["dias"][index]["temperaturaMax"],
              snapshot.data["dias"][index]["temperaturaMin"],
              "$imgTemp"),
          LinhaTempo(snapshot.data["dias"][index]["tempo"]),
          LinhaUmidade(snapshot.data["dias"][index]["umidadeMax"],
              snapshot.data["dias"][index]["umidadeMin"]),
          LinhaVentos(snapshot.data["dias"][index]["direcaoVentos"],
              snapshot.data["dias"][index]["intensidade"])
        ],
      ),
    );
  }

  Widget LinhaVentos(String direcao, String intensidade) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 0.0),
      child: Column(
        children: <Widget>[
          TituloELinha("VENTOS"),
          Descricao("$direcao/$intensidade", "vazia"),
        ],
      ),
    );
  }

  Widget Descricao(String descricao, String img) {
    if (img == "vazia") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$descricao",
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$descricao",
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
          Image.asset(
            "images/icons/$img.png",
            height: 25.0,
          ),
        ],
      );
    }
  }

  // WIDGET QUE MONTA A OS TITULOS DE CADA MOSTRAGEM
  Widget TituloELinha(String titulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "$titulo",
          style: TextStyle(
              fontSize: 19.5, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Container(
          color: Colors.white.withOpacity(0.85),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          height: 2.5,
        ),
      ],
    );
  }

  Widget LinhaTempo(String tempo) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 0.0),
      child: Column(
        children: <Widget>[
          TituloELinha("TEMPO"),
          Text("$tempo",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))
        ],
      ),
    );
  }

  Widget LinhaUmidade(String umidadeMax, String umidadeMin) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 0.0),
      child: Column(
        children: <Widget>[
          TituloELinha("UMIDADE MÁX E MÍN"),
          Descricao("$umidadeMax% - $umidadeMin%", "umidade"),
        ],
      ),
    );
  }

  Widget LinhaTemperatura(
      String diaSemana, String tempMax, String tempMin, String imgTempo) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 0.0),
      child: Column(
        children: <Widget>[
          TituloELinha("$diaSemana"),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 0.0, top: 0.0, right: 15.0, bottom: 0.0),
                child: Image.asset(
                  "images/icons/$imgTempo.png",
                  fit: BoxFit.cover,
                  height: 115.0,
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Temperatudo Máx e Mín",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "$tempMax°C - $tempMin°C",
                    style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
