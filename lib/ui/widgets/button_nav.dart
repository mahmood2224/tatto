import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tato/ui/widgets/Loading.dart';
import 'package:tato/ui/widgets/spedo_button.dart';
import 'package:tato/utils/algorithms.dart';
import 'package:tato/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class SpedoButtonNav extends StatelessWidget {
  String text ;
  String smtext ;
  String cr;
  String buttonSt;
  Function press;
  double right;
  bool loading ;
  bool buttonLoading ;
  String discount ;


  SpedoButtonNav({this.text , this.smtext , this.cr , this.buttonSt ,this.press, this.right , this.loading = false , this.buttonLoading = false ,this.discount});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: 70,
      width: width,
      color: Colors.transparent,
      child: Material(
        elevation: 10,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(right:right ?? 100,top: 11, left: 20),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             this.loading ? Loading(isBackground: false,) : Row(
               children: [
                 Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text ?? "" , style: TextStyle(fontSize: 11, color: TEXT_COLOR100),),
                      Row(
                        children: [
                          Text(convertNumbersString(smtext ?? "0") +" " , style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: TEXT_COLOR),),
                          Text(cr ?? "" , style: TextStyle(fontSize: 11, color: TEXT_COLOR100),),
                        ],
                      )
                    ],
                  ),
                this.discount == null ? Container() :  SizedBox(width: 12,),
                 this.discount == null ? Container() : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("الخصم" , style: TextStyle(fontSize: 11, color: TEXT_COLOR100),),
                      Row(
                        children: [
                          Text(convertNumbersString(discount ?? "0") +" " , style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: TEXT_COLOR),),
                          Text(cr ?? "" , style: TextStyle(fontSize: 11, color: TEXT_COLOR100),),
                        ],
                      )
                    ],
                  ),
               ],
             ),
              SpedoButton(
                height: 40,
                width: width/2.3,
                text:buttonSt ?? "" ,
                textColor: Colors.white,
                onPressed: press,
                loading: this.buttonLoading,
                icon: Container(
                  width: 25,
                  height: 25,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_forward_ios , size: 15, color: PRIMARY_COLOR,),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
