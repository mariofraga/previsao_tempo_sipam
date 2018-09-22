import 'package:flutter/material.dart';
import 'package:previsao_tempo/ui/cidades.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:previsao_tempo/ui/uteis.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //String cidadeFavorita;
  //int contadorfundo = 0;
  //String no_municipio;
  //int co_municipio = 1100015;

  var cidadeFavorita;
  Future<Map> dados;
  uteis u = new uteis();

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void initState() {
    initializeDateFormatting("pt_BR", null).then((_) => _HomeState());
    //listObjPrevisao;
    _getTempo();
    super.initState();
  }

  Future<Map> _getTempo() async {
    Map decoded = await u.readData();
    print("Entrou no get tempo");
    print(decoded);
    cidadeFavorita = decoded;
    if(cidadeFavorita["co_municipio"] == 0){
      _selecionaCidade(context);
    }
    String urlCon;
    http.Response response;
    try {
      urlCon =      "http://172.23.14.99:8000/api/previsao/ha45664Hk214g5f66l89u11gf/${cidadeFavorita["co_municipio"]}";
      response = await http.get(urlCon);
    } catch(e){
      print("Não Conectou.");
      print(e.toString());
      urlCon =      "http://www.aerofilmes.com/previsao_ok.json";
      response = await http.get(urlCon);
    }


    String body = utf8.decode(response.bodyBytes);
    return json.decode(body);
  }

  void _selecionaCidade(BuildContext c) async {
    final _recCidade = await Navigator.push(c, MaterialPageRoute(builder: (context) => Cidades()));
    print("Entrou no seleicona cidade");
      if (_recCidade != null) {
        cidadeFavorita = _recCidade;
        print("deu certo");
        print(_recCidade);
        u.writeData(json.encode(cidadeFavorita));
        print("gravou ok.");
      } else {
        print("_recCidade = null");
      }
      setState(() {
        print("print do setState");
        print(cidadeFavorita);
        cidadeFavorita = json.encode(_recCidade.toString());
      });
    }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
      child: FutureBuilder(
          future: _getTempo(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
              case (ConnectionState.none):
                return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 120.0,
                                    child: Image.asset(
                                      "images/icons/icsipam_grande.png",
                                      height: 500.0,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  );
              default:
                if (snapshot.hasError)
                  return Container();
                else
                  return DefaultTabController(
                    length: 4,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Colors.lightGreen[900],
                        centerTitle: true,
                        title: FlatButton(
                            onPressed: () {
                              _selecionaCidade(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Image.asset(
                                    "images/icons/icsipam.png",
                                    height: 60.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                //new Image.asset('images/favicon.ico', width: 32.0,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Previsão do Tempo na Amazônia",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    Text("$cidadeFavorita",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            )),
                        bottom: TabBar(
                          labelColor: Colors.amber,
                          unselectedLabelColor: Colors.white,
                          tabs: List<Widget>.generate(
                              snapshot.data["dias"].length, (index) {
                            return Tab(
                              child: Text(
                                index == 0
                                    ? "Hoje"
                                    : snapshot.data["dias"][index]["dt_data_previsao"],
                                style: TextStyle(fontSize: 12.0),
                              ),
                            );
                          }),
                        ),
                      ),
                      body: Container(
                        color: Colors.black38,
                        child: TabBarView(
                          children: List<Widget>.generate(
                              snapshot.data["dias"].length, (index) {
                            return pagePrevisaoTempo(snapshot, "0${index + 1}",
                                AlignmentDirectional.centerStart, index);
                          }),
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          _selecionaCidade(context);
                        },
                        backgroundColor: Colors.lightGreen[700],
                        tooltip: 'Inbox',
                        child: Icon(
                          Icons.location_on,
                          textDirection: TextDirection.rtl,
                          color: Colors.white,
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
              "day week",
              snapshot.data["dias"][index]["nu_temperatura_maxima"],
              snapshot.data["dias"][index]["nu_temperatura_minima"],
              "$imgTemp"),
          LinhaTempo(snapshot.data["dias"][index]["tempo"], snapshot.data["dias"][index]["chuva"]),
          LinhaUmidade(snapshot.data["dias"][index]["nu_umidade_maxima"],
              snapshot.data["dias"][index]["nu_umidade_minima"]),
          LinhaVentos(snapshot.data["dias"][index]["no_direcao_vento"], snapshot.data["dias"][index]["no_direcao_vento_variacao"], snapshot.data["dias"][index]["vento"], snapshot.data["dias"][index]["vento_variacao"],)
        ],
      ),
    );
  }

  Widget LinhaVentos(String ventodirecao, String direcaoVariacao, String vento, String ventoVariacao) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 0.0),
      child: Column(
        children: <Widget>[
          TituloELinha("VENTOS"),
          Descricao("$ventodirecao/$direcaoVariacao - $vento/$ventoVariacao", "vazia"),
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

  Widget LinhaTempo(String tempo, String chuva) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 0.0),
      child: Column(
        children: <Widget>[
          TituloELinha("TEMPO"),
          Text("$tempo, $chuva",
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
