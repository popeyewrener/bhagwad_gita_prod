import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UserRepos {
  final String baseurl = 'https://gita-api.vercel.app/';
  createlocal({result, chapter, verse}) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      var extdir = await getApplicationDocumentsDirectory();
      final filename = "${chapter}_$verse";
      final dirPath = '${(extdir)!.path}/${chapter}_$verse/';
      await Directory(dirPath).create();
      final file = File("${(extdir).path}/${chapter}_$verse/$filename.json");
      await file.writeAsString(json.encode(result));
      //var membytes = await file.readAsString();
    }
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<bool> checklocal({chapter, verse}) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      var extdir = await getApplicationDocumentsDirectory();
      final filename = "${chapter}_$verse";
      if (await File("${(extdir)!.path}/${chapter}_$verse/$filename.json")
              .exists() ==
          true) {
        return true;
      } else {
        return false;
      }
    }
    if (status.isDenied) {
      await Permission.storage.request();
    }
    return false;
  }

  Future getverse(lang, chapter, verse) async {
    bool isavailablelocal = await checklocal(chapter: chapter, verse: verse);
    if (isavailablelocal == true) {
      final filename = "${chapter}_$verse";
      var extdir = await getApplicationDocumentsDirectory();
      final file = File("${(extdir)!.path}/${chapter}_$verse/$filename.json");
      String strout = await file.readAsString();
      var result = json.decode(strout);
      return {
        'chapter_no': result['chapter_no'],
        'verse_no': result['verse_no'],
        'language': result['language'],
        'chapter_name': result['chapter_name'],
        'verse': result['verse'],
        'transliteration': result['transliteration'] ?? '',
        'synonyms': result['synonyms'],
        'audio_link': result['audio_link'],
        'translation': result['translation'],
        'purport': result['purport']
      };
    } else {
      var uri = Uri.https('gita-api.vercel.app', '$lang/verse/$chapter/$verse');
      print(uri);
      Response response = await get(uri, headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes));
        await createlocal(result: result, chapter: chapter, verse: verse);

//User.fromJson(file.readAsString());
        print((result.runtimeType));
        return {
          'chapter_no': result['chapter_no'],
          'verse_no': result['verse_no'],
          'language': result['language'],
          'chapter_name': result['chapter_name'],
          'verse': result['verse'],
          'transliteration': result['transliteration'] ?? '',
          'synonyms': result['synonyms'],
          'audio_link': result['audio_link'],
          'translation': result['translation'],
          'purport': result['purport']
        };
      } else {
        throw Exception(response.reasonPhrase);
      }
    }
  }
}
