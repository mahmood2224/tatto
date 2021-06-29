import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String ARABIC = "ar";
const String ENGLISH = "en";

changeLanguage({@required String lang, @required BuildContext context}) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  int selectedLangIndex = lang == "en" ? 0 : 1;
  // ignore: unnecessary_statements
  EasyLocalization.of(context).supportedLocales[selectedLangIndex];
  log("saving language : $lang", name: "localization Helper");
  _pref.setString("lang", lang);
  return;
}

Future<String> getLanguage() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String lang = _pref.getString("lang")??"ar";
  log("getting language : $lang", name: "localization Helper");
  return lang;
}
