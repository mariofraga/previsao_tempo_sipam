import 'package:flutter/material.dart';
import 'package:previsao_tempo/ui/cidades.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String cidadeFavorita;

  @override
  void initState() {
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
                child: Text("Hoje"),
              ),
              Tab(
                child: Text("12/09/2018"),
              ),
              Tab(
                child: Text("13/09/2018"),
              ),
            ],
          ),
        ),
        body:
        Container( child:
        TabBarView(
          children: [
            pagePrevisaoTempo(
                "SEGUNDA-FEIRA",
                "36",
                "25",
                "Claro a parcialmente nublado com possibilidade de chuva em áreas isoladas",
                "60",
                "20",
                "N-NW",
                "Fracos")
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

}

Widget pagePrevisaoTempo(String diaSemana, String max, String min, String tempo,
    String umidadeMax, String umidadeMin, String direcao, String intensidade) {
  return Container(
    decoration: new BoxDecoration(
      color: Colors.black87,
      image: new DecorationImage(
        image: new AssetImage("images/sol2.jpg"),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          LinhaTemperatura("$diaSemana", "$max", "$min"),
          LinhaTempo("$tempo"),
          LinhaUmidade("$umidadeMax", "$umidadeMin"),
          LinhaVentos("$direcao", "$intensidade")
        ],
      ),
  );
}

Widget LinhaTemperatura(String diaSemana, String max, String min) {
  return Padding(
    padding: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 0.0),
    child: Column(
      children: <Widget>[
        TituloELinha("$diaSemana"),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 0.0, top: 0.0, right: 15.0, bottom: 0.0),
              child: Image.asset(
                "images/icons/01.png",
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
                  "$max°C - $min°C",
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
    padding: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 0.0),
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

Widget LinhaUmidade(String max, String min) {
  return Padding(
    padding: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 0.0),
    child: Column(
      children: <Widget>[
        TituloELinha("UMIDADE MÁX E MÍN"),
        Descricao("$max% - $min%", "umidade"),
      ],
    ),
  );
}

Widget LinhaVentos(String direcao, String intensidade) {
  return Padding(
    padding: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 0.0),
    child: Column(
      children: <Widget>[
        TituloELinha("VENTOS - DIREÇÃO E INTENSIDADE"),
        Descricao("$direcao/$intensidade", "ventos"),
      ],
    ),
  );
}
// WIDGET QUE MONTA A OS DESCRIÇÃO DE CADA MOSTRAGEM

Widget Descricao(String descricao, String img) {
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

// WIDGET QUE MONTA A OS TITULOS DE CADA MOSTRAGEM
Widget TituloELinha(String titulo) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Text(
        "$titulo",
        style: TextStyle(fontSize: 20.0, color: Colors.white),
      ),
      Container(
        color: Colors.white.withOpacity(0.85),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        height: 2.5,
      ),
    ],
  );
}
