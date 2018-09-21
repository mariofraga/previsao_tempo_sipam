import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class uteis {

  var strInicio = {'co_municipio':0,'no_municipio':0};

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {

    try {
      final path = await _localPath;
      return File('$path/Favorito777.json');
    } catch( e){
      writeData(json.encode(strInicio));
    }
   }

  Future<Map> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return json.decode(body);
    } catch (e) {
      print(e.toString());
      return strInicio;
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    print("Arquivo a ser gravado: ${data}");
    return file.writeAsString("$data");
  }
}
