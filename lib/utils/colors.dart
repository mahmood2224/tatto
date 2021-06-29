import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

 Color PRIMARY_COLOR = Color(0xffF85252);
 Color PRIMARY_COLOR_70 = Color(0xffF85252);
 Color PRIMARY_COLOR_30 = Color(0xffF85252);

const Color ACCENT_COLOR = Color(0xbb00618F);
const Color FONT_COLOR_WHITE = Colors.white ;
const Color BACKGROUND_COLOR = Colors.white ;
const Color GREY_COLOR = Color(0xffE4E4E4);
const Color GREY_COLOR100 = Color(0x11000000);
const Color BOTTOM_BAR_COLOR = Color(0xff00618F);
const Color TEXT_COLOR = Color(0xff353535);
const Color TEXT_COLOR100 = Color(0xff707070);
const Color LOGO_COLOR = Color(0xffE83024);
const Color INPUT_BACKGROUND = Color(0xffEAF5FF);


Future<void> saveColor(String color) async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString("primary_color", color);
}

Future<Color> getColor(int number)async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String color = _prefs.getString("primary_color")??"000000";
  color = color.replaceAll("#", "");
  return new Color(int.parse(color, radix: 16) + number);
}

bindColor()async{
  PRIMARY_COLOR = await getColor(0xFF000000);
  PRIMARY_COLOR_70 = await getColor(0x99000000);
  PRIMARY_COLOR_30 = await getColor(0x44000000);
}