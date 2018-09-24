import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class uteis {

  String strInicio = ''' {"co_municipio":0,"no_municipio":"Selecione A Cidade"} ''';
  String nomeArquivo = "Favoritaaerofilmes.json";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    File arquivo;
    try {
      print("Entrou. no local,");
      final path = await _localPath;
      print("passou do pat");
      if(FileSystemEntity.typeSync('$path/$nomeArquivo') != FileSystemEntityType.NOT_FOUND) {
        arquivo = File('$path/$nomeArquivo');
      } else {
        arquivo = File('$path/$nomeArquivo');
      }
      print("passou do Arquivo!.");
      return arquivo;
      } catch(e){
      print("erro na leitura do arquivo.");
       writeData(json.encode(strInicio));
    }
   }

  Future<Map> readData() async {
    try {
      final file = await localFile;
      final path = await _localPath;
      if(FileSystemEntity.typeSync('$path/$nomeArquivo') != FileSystemEntityType.NOT_FOUND) {
        String body = await file.readAsString();
        return json.decode(body);
      } else {
        return json.decode(strInicio);
      }
    } catch (e) {
      print(e.toString());
      return json.decode(strInicio);
    }
  }

  Future<File> writeData(String data) async {
    print("entrou no write.");
    Future<File> Arquivo;

    try{
      final file = await localFile;
      print("Arquivo a ser gravado!!!: ${data}");
      Arquivo = file.writeAsString("${data}");
      return Arquivo;
    } catch (e){
      print("Erro na Gravacao do Arquivo");
      print(e.toString());
      return null;
    }

  }
}
