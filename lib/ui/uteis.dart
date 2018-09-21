import 'dart:convert';
import 'dart:async' show Future;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class uteis {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await _localPath;
    return File('$path/favorito50.json');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return "{ \"co_municipio\":0, \"no_municipoo\":0 }";
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}
