import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tato/utils/colors.dart';

class DropDownModel{
  String name ;
  dynamic object ;
  bool isSelected ;
  DropDownModel({this.name, this.object , this.isSelected = false });

}

class SpedoDropdown extends StatefulWidget {
  String label;

  Color textColor;

  String error ;
  
  double height;

  double width;


  List<DropDownModel> items;

  Function onSelectItem;
  
  Color backgroundColor ;

  BoxDecoration decoration ;

  IconData icon ;

  Alignment textAlign ;



  SpedoDropdown({
    this.label="",
    this.textAlign ,
    this.textColor,
    this.height = 40,
    this.width,
    this.items  ,
    this.icon ,
    this.onSelectItem,
    this.error="",
    this.backgroundColor,
    this.decoration
  });

  @override
  _SpedoDropdownState createState() {
    return _SpedoDropdownState();
  }
}

class _SpedoDropdownState extends State<SpedoDropdown> {
  dynamic value ;
  bool itemSelected = false ;

  @override
  void initState() {
    super.initState();
    print("init state for dropDown triggerd ");

  }

  @override
  void dispose() {
    super.dispose();
  }
   get fontColor => widget.backgroundColor != Colors.white ? TEXT_COLOR100: TEXT_COLOR100;
  @override
  Widget build(BuildContext context) {
    if(!itemSelected){
      widget.items.forEach((element) {
        if(element.isSelected) {
          setState(() =>value = element.object);
          new Timer(Duration(milliseconds: 100), ()=>widget.onSelectItem(element.object));

        }
      });
    }
    return Container(

       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children: <Widget>[
          widget.label.isEmpty ? Container(): Align(
               alignment: AlignmentDirectional.centerStart,
               child: Text(widget.label ?? "")),
           widget.label.isEmpty ? Container(): SizedBox(
             height: 8,
           ),
           Container(
             decoration:widget.decoration ??  BoxDecoration(
                 color: widget.backgroundColor ?? GREY_COLOR,
                 borderRadius: BorderRadius.circular(10)
             ),
             height:  widget.height,
             width:widget.width,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 DropdownButton(
                   underline: Container(),
                   value:this.value ,
                   icon: Icon(widget.icon ?? Icons.arrow_drop_down , size: 20, color:widget.textColor ?? fontColor,),
                   items: widget.items.map((DropDownModel value) {
                     return new DropdownMenuItem(
                       value: value.object,
                       child:  Container(
                           width:   widget.width-68.0 ,
                           child: Align( alignment: widget.textAlign ?? AlignmentDirectional.centerStart,child: Text(value?.name??"لا يوجد اسم" ,style:  TextStyle(color: widget.textColor ?? fontColor ,fontSize:  14),))),
                     );
                   }).toList(),
                   onChanged: (value) {
                     this.itemSelected = true ;
                     setState(() => this.value = value);
                     widget.onSelectItem(value);
                   },
                 ),
               ],
             ),
           ),
          widget.error.isEmpty ?Container(): SizedBox(
             height: 8,
           ),
           widget.error.isEmpty ?Container(): Align(
               alignment: AlignmentDirectional.centerStart,
               child: Text(widget.error??""  ,style: TextStyle(fontSize: 10 ,color: Colors.red),)),

         ],
       ),
     );;
  }
}
