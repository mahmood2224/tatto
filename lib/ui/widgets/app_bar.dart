import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tato/data/model/sent/counts_model.dart';
import 'package:tato/ui/views/shopping_cart.dart';
import 'package:tato/ui/widgets/Logo.dart';
import 'package:tato/ui/widgets/badge.dart';
import 'package:tato/utils/colors.dart';

PreferredSize SpedoAppBar(BuildContext context,
    {String title = "",Widget titleWidget, GlobalKey<ScaffoldState> scaffoldKey , List<Widget> actions  , Widget leading , Count counts , Function getCounts}) {
  return PreferredSize(
    child: Container(
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
          title:titleWidget ?? (title.isNotEmpty
              ? Text(
                  title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              : Logo()),
          actions:[
            SizedBox(width: 16,),
            ... actions??[],
            getCounts == null ? Container() :InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ShoppingCart()),
                );
                getCounts();
              },
              child: Container(
                width: 58,
                height: 58,
                child: CustomBadge(
                  backgroundColor: PRIMARY_COLOR,
                  badgeCount: counts?.count,
                  child: SvgPicture.asset(
                    "assets/icons/cart.svg",
                    width: 25,
                    height: 25,
                    color: PRIMARY_COLOR,
                  ),
                ),
              ),
            ),

          ],
          leading:leading ?? InkWell(
            onTap: ()=>Navigator.pop(context),
              child:Icon(Icons.arrow_back_ios , color: PRIMARY_COLOR,)),
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 18, //change your color here
          )),
    ),
    preferredSize: Size.fromHeight(60),
  );
}
