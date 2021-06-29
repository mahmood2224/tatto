
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/utils/colors.dart';

class SpedoButton extends StatelessWidget {
  String text ;
  Function onPressed ;
  double width ;
  double height ;
  BoxDecoration decoration;
  Color textColor ;
  bool loading ;
  Widget frontIcon ;
  double borderRadius ;
  bool textLoading ;
  Widget icon;
  double fontSize ;


  SpedoButton({this.text, this.onPressed,this.fontSize = 16, this.frontIcon ,this.width, this.height ,this.decoration ,this.textColor,this.loading =false, this.borderRadius,this.textLoading=false , this.icon });

  @override
  Widget build(BuildContext context) {
    return this.loading ? Loading():InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? 200,
        height: height ?? 60,
        decoration: decoration ?? BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(borderRadius?? 10)
        ),
        child: this.textLoading ? Loading() :Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            this.frontIcon??Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(text??"" , style: TextStyle(color: textColor??Colors.white , fontSize: fontSize , fontWeight: FontWeight.bold),),
            ),
            this.icon??Container()
          ],
        ),
      ),
    );
  }
}