import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class KintukyHouseTextField extends StatelessWidget {
  TextEditingController controller;
  String hint;
  double width;
  double height;
  bool obscure;
  String icon;
  Function onTextChange;
  String label;
  Widget iconWidget ;
  double border;
 Color backgroundColor ;
 bool withBoarders ;
 Color boarderColor ;
 TextAlign textAlign ;
  TextInputType textType ;
  KintukyHouseTextField(
      {this.controller,
      this.hint = "",
      this.width = 200,
      this.height = 48,
      this.obscure = false,
      this.onTextChange,
      this.icon,
        this.textAlign ,
        this.boarderColor ,
        this.backgroundColor,
      this.label ,
        this.withBoarders = true ,
      this.iconWidget,
      this.border , this.textType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: BoxConstraints(minHeight: label != null ? 64 : height),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: this.backgroundColor??Color(0xffffffff),
        borderRadius: BorderRadius.circular(border ?? 8),
        border:withBoarders ? Border.all(color: backgroundColor??Color(0xff2D2D2D), width: 1) : null ,
      ),
      child: Row(


        children: [
          icon == null ? Container() : Image.asset(icon),
          Container(
            width: icon == null ? width-34 : width-34-25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: icon != null ? (iconWidget==null ? width-34 :width - 34 -105) -25 : (iconWidget==null ? width-34 :width - 34 -105),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...label == null
                          ? []
                          : [
                        Text(
                          "$label",
                          style: TextStyle(fontSize: 10 ,color: Colors.red),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                      Container(
                        height: 26,
                        width: width - 34,
                        margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: TextField(
                            controller: controller ?? new TextEditingController(),
                            textAlign: this.textAlign ?? TextAlign.start,
                            obscureText: obscure,
                            keyboardType: this.textType ?? TextInputType.text,
                            onChanged: this.onTextChange ?? (text) {},
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: hint,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                iconWidget == null ? Container(): Container(
                  height: height ,
                  padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child: iconWidget,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
