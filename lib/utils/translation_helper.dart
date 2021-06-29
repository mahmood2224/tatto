import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

void main(){
  _searchAndTranslation();
}

void _searchAndTranslation({Directory dir }){
  Directory project = dir ?? new Directory("D:/FlutterProject/spedo_sales/lib");
  List contents = project.listSync();
  for(var dirOrFile in contents){
    if(dirOrFile is File){
      print ("File Name : ${ basename(dirOrFile.path)} in directorry ${basename(project.path)}");
      _translate(file: dirOrFile);
    }else {
      _searchAndTranslation(dir: dirOrFile);
    }
  }
}

void _translate({File file}) async {
  String content = await file.readAsString();
  RegExp regExp = new RegExp('"[(A-Z)(a-z)_]+"\.tr\(\)');
  Iterable<RegExpMatch> matches = regExp.allMatches(content);
  File arFile = new File("D:/FlutterProject/spedo_sales/assets/lang/ar-SA.json");
  File enFile = new File("D:/FlutterProject/spedo_sales/assets/lang/en-US.json");
  Map<String,dynamic> jsonAr = json.decode(arFile.readAsStringSync());
  Map<String,dynamic> jsonEn = json.decode(enFile.readAsStringSync());

  matches.forEach((match) {
    String word = content.substring(match.start, match.end);
    String tag = word.split(".")[0];
    if(!jsonAr.containsKey(tag.replaceAll('"', "")))
    jsonAr[tag.replaceAll('"', "")] = tag.replaceAll("_", " ").replaceAll('"', "");
    if(!jsonEn.containsKey(tag.replaceAll('"', "")))
    jsonEn[tag.replaceAll('"', "")] = tag.replaceAll("_", " ").replaceAll('"', "");
  });
  arFile.writeAsStringSync(json.encode(jsonAr).replaceAll(",", ",\n"));
  enFile.writeAsStringSync(json.encode(jsonEn).replaceAll(",", ",\n"));
}