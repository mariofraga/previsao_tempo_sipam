import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[900],
          centerTitle: true,
          title: Text("Previsão do Tempo Porto Velho",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold)),
          bottom: TabBar(
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
        body: TabBarView(
          children: [pagePrevisaoTempo("SEGUNDA-FEIRA", 25)],
        ),
      ),
    );
  }
}

Widget pagePrevisaoTempo(String diaSemana, int graus) {
  return Stack(
    children: <Widget>[
      Image.asset(
        "images/dia-am.png",
        fit: BoxFit.cover,
        height: 500.0,
      ),
      Column(
        children: <Widget>[
          linhaTempo(diaSemana, graus),
          linhaMaxMin(),
          linhaUmidade(),
          linhaVentos()
        ],
      ),
    ],
  );
}

Widget linhaTempo(String diaSemana, int graus) {
  return Padding(
    padding: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 0.0),
    child: Column(
      children: <Widget>[
        tituloELinha("$diaSemana"),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 15.0, bottom: 0.0),
              child: Image.asset(
                "images/01.png",
                fit: BoxFit.cover,
                height: 115.0,
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  "$graus° C",
                  style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic),
                ),
                Text(
                  "Tempo Claro",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "Parcialmente Nublado",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget linhaMaxMin() {
  return Padding(
    padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 0.0),
    child: Column(
      children: <Widget>[
        tituloELinha("MÁX E MÍN"),
        descricao("60% - 20%"),
      ],
    ),
  );
}

Widget linhaUmidade() {
  return Padding(
    padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 0.0),
    child: Column(
      children: <Widget>[
        tituloELinha("MÁX E MÍN"),
        descricao("60% - 20%"),
      ],
    ),
  );
}

Widget linhaVentos() {
  return Padding(
    padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 0.0),
    child: Column(
      children: <Widget>[
        tituloELinha("MÁX E MÍN"),
        descricao("60% - 20%"),
      ],
    ),
  );
}
Widget descricao(String descricao){
  return Row(
    children: <Widget>[
      Text(
        "$descricao",
        style: TextStyle(fontSize: 30.0, color: Colors.white),
      ),
    ],
  );
}

Widget tituloELinha(String titulo) {
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