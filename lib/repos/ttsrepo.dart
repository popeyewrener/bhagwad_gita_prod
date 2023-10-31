import 'dart:convert';

import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Ttsrepo {
  final String baseurl = 'https://tts-api.ai4bharat.org';
  Future requesttts(text, lang, gender) async {
    var body = {
      "input": [
        {
          "source": "$text",
        }
      ],
      "config": {
        "gender": '$gender',
        "language": {"sourceLanguage": '$lang'}
      }
    };
    var header = {
      'Content-Type': 'application/json',
    };

    Dio dio = Dio();
    print('asking response');
    Response response = await dio.post(baseurl,
        data: jsonEncode(body), options: Options(headers: header));
    if (response.statusCode == 200) {
      print('got response');
      var result = response.data;
      var base64out = result["audio"][0]['audioContent'];
      print('got baseout');
      return base64out;
      //var base = result["audio"][0]['audioContent'];

    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory!.path;
  }

  checklocalaudio(file) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      var extdir = await getApplicationDocumentsDirectory();

      if (await File("${(extdir)!.path}/$file/$file.wav").exists() == true) {
        return true;
      } else {
        return false;
      }
    }
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  getlocalaudio(fileid) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      final path = await localPath;
      final file = File('$path/$fileid/${fileid}.wav');
      return (file);
    }
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<File> localFile(filename, pathname) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      final path = await localPath;
      final dirpath = "$path/$pathname";
      await Directory(dirpath).create();
      return File('$path/$pathname/$filename.wav');
    }
    if (status.isDenied) {
      await Permission.storage.request();
    }
    return File('');
  }

  /* Future<String> _createFileFromString() async {
final encodedStr = "put base64 encoded string here";
Uint8List bytes = base64.decode(encodedStr);
String dir = (await getApplication).path;
File file = File(
    "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
await file.writeAsBytes(bytes);
return file.path;
 }*/
}
