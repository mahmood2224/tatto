import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tato/utils/colors.dart';

class CustomBadge extends StatelessWidget {
  int badgeCount ;
  Widget child;

  bool withBoarders ;
  Color backgroundColor ;

  CustomBadge({this.badgeCount, this.child , this.backgroundColor , this.withBoarders = true });

  @override
  Widget build(BuildContext context) {
    return Container(

        child: Stack(
        alignment: Alignment.center,
        children: [

          child,
          this.badgeCount== null ?Container() :PositionedDirectional(
            top: 8,
            start: 8,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: this.backgroundColor ?? Colors.white,
                  border: Border.all(color: this.backgroundColor != null? Colors.white:  PRIMARY_COLOR , width: 3)
              ),
              child: Center(child: Text("${this.badgeCount??0}" , style: TextStyle(color: this.backgroundColor != null ? Colors.white: PRIMARY_COLOR , fontSize: 8 , fontWeight: FontWeight.bold),)),
            ),
          ),
        ],
      ),
    );
  }
}
