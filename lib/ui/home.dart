import 'package:flutter/material.dart';
import 'package:previsao_tempo/ui/cidades.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Previsaotempo> listObjPrevisao = new List<Previsaotempo>();
  String cidadeFavorita;

  @override
  void initState() {
    carregarPrevisao();
    super.initState();
    print("ok");
    if (cidadeFavorita == null || cidadeFavorita.isEmpty) {
      cidadeFavorita = "Porto Velho";
    } else {
      cidadeFavorita = "outra";
    }
  }

  @override
  Widget build(BuildContext context) {
    return getPageHomeDados(context);
  }

  //CARREGAR INFORMAÇÕES DO JSON DE PREVISÃO
  Future<String> _loadCrosswordAsset() async {
    return await rootBundle.loadString('assets/data/previsaoTempo.json');
  }

  Future<Map> loadCrossword() async {
    Map decoded = json.decode(await _loadCrosswordAsset());
    return decoded;
  }

  void carregarPrevisao() async {
    Map decoded = await loadCrossword();
    for (var dias in decoded["dias"]) {
      listObjPrevisao.add(Previsaotempo(
          dias["data"],
          dias["nomeCidade"],
          dias["tempo"],
          dias["temperaturaMax"],
          dias["temperaturaMin"],
          dias["umidadeMax"],
          dias["umidadeMin"],
          dias["direcaoVentos"],
          dias["intensidade"],
          dias["diaSemana"]));
    }
    setState(() {
      this.listObjPrevisao = listObjPrevisao;
    });
  }
  //FIM CARREGAR INFORMAÇÕES DO JSON DE PREVISÃO

  void _selecionaCidade(BuildContext c) async {
    final _recCidade = await Navigator.push(c,
        MaterialPageRoute(
            builder: (context) => Cidades()));
    if (_recCidade != null) {
      if (_recCidade != null) {
        cidadeFavorita = _recCidade;
      } else {
        cidadeFavorita = "nenhuma";
      }
      setState(() {});
    }
  }

  //WIDGET QUE CONSTROI A PAGINA INICIAL COM OS DADOS DO JSON
  Widget getPageHomeDados(BuildContext context) {
    // PEGANDO A DATA ATUAL E COMPARANDO COM A DO PRIMEIRO OBJETO DA LISTA
    String hoje;
    var data = DateTime.now();
    if(listObjPrevisao[0].data == "${data.day}/0${data.month}/${data.year}"){
      hoje = "Hoje";
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[900],
          centerTitle: true,
          title: Text("Previsão do Tempo $cidadeFavorita",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          bottom:
          TabBar(
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                child: Text(hoje),
              ),
              Tab(
                child: Text(listObjPrevisao[1].data),
              ),
              Tab(
                child: Text(listObjPrevisao[2].data),
              ),
            ],
          ),
        ),
        body:
        Container( child:
        TabBarView(
          children: [
            pagePrevisaoTempo(listObjPrevisao[0], "01"),
            pagePrevisaoTempo(listObjPrevisao[1], "02"),
            pagePrevisaoTempo(listObjPrevisao[2], "03"),
          ],
        ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _selecionaCidade(context);
          },
          backgroundColor: Colors.lightGreen[900],
          tooltip: 'Inbox',
          child: Icon(Icons.location_on),
        ),
      ),
    );
  }
}

Widget pagePrevisaoTempo(Previsaotempo objPrevTemp, String imgTemp) {
  return Container(
    decoration: new BoxDecoration(
      color: Colors.black87,
      image: new DecorationImage(
        image: new AssetImage("images/sol2.jpg"),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
        children: <Widget>[
          LinhaTemperatura(objPrevTemp.diaSemana, objPrevTemp.temperaturaMax, objPrevTemp.temperaturaMin, "$imgTemp"),
          LinhaTempo(objPrevTemp.tempo),
          LinhaUmidade(objPrevTemp.umidadeMax, objPrevTemp.umidadeMin),
          LinhaVentos(objPrevTemp.direcaoVentos, objPrevTemp.intensidade)
        ],
      ),
  );
}

Widget LinhaTemperatura(String diaSemana, String tempMax, String tempMin, String imgTempo) {
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

Widget LinhaVentos(String direcao, String intensidade) {
  return Padding(
    padding: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0, bottom: 0.0),
    child: Column(
      children: <Widget>[
        TituloELinha("VENTOS - DIREÇÃO E INTENSIDADE"),
        Descricao("$direcao/$intensidade", "vazia"),
      ],
    ),
  );
}
// WIDGET QUE MONTA A OS DESCRIÇÃO DE CADA MOSTRAGEM

Widget Descricao(String descricao, String img) {
  if(img == "vazia"){
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
        style: TextStyle(fontSize: 19.5, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Container(
        color: Colors.white.withOpacity(0.85),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        height: 2.5,
      ),
    ],
  );
}

class Previsaotempo {
  String data;
  String nomeCidade;
  String tempo;
  String temperaturaMax;
  String temperaturaMin;
  String umidadeMax;
  String umidadeMin;
  String direcaoVentos;
  String intensidade;
  String diaSemana;

  Previsaotempo(
      this.data,
      this.nomeCidade,
      this.tempo,
      this.temperaturaMax,
      this.temperaturaMin,
      this.umidadeMax,
      this.umidadeMin,
      this.direcaoVentos,
      this.intensidade,
      this.diaSemana);
}
