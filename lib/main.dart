import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

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
              style: TextStyle(fontSize: 15.0)),
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
          children: [
            pagePrevisaoTempo("SEGUNDA-FEIRA", 25),
            pagePrevisaoTempo("TERÇA-FEIRA", 22),
            pagePrevisaoTempo("QUARTA-FEIRA", 28)
          ],
        ),
      ),
    );
  }
}

Widget pagePrevisaoTempo(String diaSemana, int graus) {
  return  Stack(
      children: <Widget>[
        Image.asset(
          "images/dia-larga-transparente.png",
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

Widget linhaTempo(String diaSemana, int graus){
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(
            left: 20.0, top: 5.0, right: 20.0, bottom: 0.0),
        child: FocusScope(
          node: FocusScopeNode(),
          child: TextFormField(
            style: TextStyle(fontSize: 20.0, color: Colors.black),
            decoration: InputDecoration(
              hintText: "$diaSemana",
            ),
          ),
        ),
      ),
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 5.0),
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
                style: TextStyle(fontSize: 50.0),
              ),
              Text(
                "Tempo Claro",
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                "Parcialmente Nublado",
                style: TextStyle(fontSize: 18.0),
              )
            ],
          ),
        ],
      ),
    ],
  );
}

Widget linhaMaxMin(){
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(
            left: 20.0, top: 0.0, right: 20.0, bottom: 0.0),
        child: FocusScope(
          node: FocusScopeNode(),
          child: TextFormField(
            style: TextStyle(fontSize: 20.0, color: Colors.black),
            decoration: InputDecoration(
              hintText: "MÁX E MÍN",
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0, bottom: 0.0),
        child: Row(
          children: <Widget>[
            Text("38°C - 23°C", style: TextStyle(fontSize: 30.0, color: Colors.black),),
          ],
        ),
      ),
    ],
  );
}
Widget linhaUmidade(){
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(
            left: 20.0, top: 0.0, right: 20.0, bottom: 0.0),
        child: FocusScope(
          node: FocusScopeNode(),
          child: TextFormField(
            style: TextStyle(fontSize: 20.0, color: Colors.black),
            decoration: InputDecoration(
              hintText: "UMIDADE MÁX E MÍN",
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0, bottom: 0.0),
        child: Row(
          children: <Widget>[
            Text("60% - 20%", style: TextStyle(fontSize: 30.0, color: Colors.black),),
          ],
        ),
      ),
    ],
  );
}
Widget linhaVentos(){
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(
            left: 20.0, top: 0.0, right: 20.0, bottom: 0.0),
        child: FocusScope(
          node: FocusScopeNode(),
          child: TextFormField(
            style: TextStyle(fontSize: 20.0, color: Colors.black),
            decoration: InputDecoration(
              hintText: "VENTOS - DIREÇÃO E INTENSIDADE",
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0, bottom: 0.0),
        child: Row(
          children: <Widget>[
            Text("SE-E / Fracos", style: TextStyle(fontSize: 30.0, color: Colors.black),),
          ],
        ),
      ),
    ],
  );
}