import 'dart:developer';
import 'dart:ui';

TextDirection getTextDirection(String lang){
  log("language to get Direction to : $lang" , name: "Actions");
  return lang == "ar" ? TextDirection.rtl : TextDirection.ltr ;
}