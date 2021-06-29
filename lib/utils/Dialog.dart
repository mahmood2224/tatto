import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tato/ui/widgets/spedo_text_field.dart';
import 'package:tato/utils/colors.dart';
import 'package:tato/ui/widgets/spedo_text_field.dart';

// ignore: non_constant_identifier_names
ShowDialog({@required BuildContext context ,  Widget child , double opacity = 0.5 ,double height , EdgeInsets margin  ,BorderRadius radius , Alignment alignment}){
  showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(opacity),
    transitionDuration: Duration(milliseconds: 100),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return child ;
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0)
            .animate(anim1),
        child:  Align(
          alignment: alignment ?? Alignment.center,
          child: Container(
            height: height ,
            child: SizedBox.expand(
                child: Material(
                  borderRadius: radius ?? BorderRadius.circular(0),
                  child: ClipRRect(
                      borderRadius: radius ?? BorderRadius.circular(0),
                      child: child),
                )),
            margin: margin ?? EdgeInsets.only(
                bottom: 16, left: 12, right: 12),
          ),
        ),
      );
    },
  );
}
showOptionsDialog({@required BuildContext context ,String title  ,void onAccept() , void onReject() }){
  ShowDialog(context: context , child: Container(
    color: Colors.white,
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10,),
        SvgPicture.asset("assets/icons/delete_icon.svg" , width: 48, height: 48,),
        SizedBox(height: 10,),
        Text("$title" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold ),),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: ()=>onAccept(),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(0xffC7463B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text("confirm".tr() , style: TextStyle(fontSize: 14 ,fontWeight: FontWeight.w500 ,color:FONT_COLOR_WHITE), ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: onReject ?? ()=>Navigator.of(context).pop(),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey , width: 1)
                    ),
                    child: Center(
                      child: Text("cancel".tr() , style: TextStyle(fontSize: 14 ,fontWeight: FontWeight.w500 ,color:Colors.grey), ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
      ],
    ),
  ) , height: 270,radius: BorderRadius.circular(13));
}
showAlertDialog(BuildContext context  , {String title , String desc}) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("تم"),
    onPressed: () { Navigator.of(context).pop();},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title??"" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: PRIMARY_COLOR),),
    content: Text(desc??"" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w500),),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
searchDialog(BuildContext context , {Function onSearchCompleted , String searchText =""}) async {
  TextEditingController _search = new TextEditingController() ;
  FocusNode _searchFocus = new FocusNode() ;
  print("showing Search dialog ");
  if( searchText.isNotEmpty){
    _search.text = searchText ;
    _search.selection = TextSelection(baseOffset: 0 , extentOffset: _search.text.length);
    _searchFocus.requestFocus();
  }
    ShowDialog(context: context , alignment: Alignment.topCenter , margin: EdgeInsets.symmetric(horizontal: 16 , vertical: 45) ,radius: BorderRadius.circular(15), height: 45 , child: Container(
      width: MediaQuery.of(context).size.width-32,
      height: 45,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width-50-32,
            padding: EdgeInsets.only(right: 16 , left: 16 , top: 8 ),
            child: Center(
              child: TextField(
                controller: _search,
                textAlign:  TextAlign.start,
                keyboardType:  TextInputType.text,
                focusNode: _searchFocus,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "search_here".tr(),
                ),
              ),
            ),
          ),
          InkWell( onTap: (){
            onSearchCompleted(_search.text);
            Navigator.pop(context);
          },child: Text("بحث" , style: TextStyle(color: PRIMARY_COLOR , fontWeight: FontWeight.bold , fontSize: 18),))
        ],
      ),
    ));
  }