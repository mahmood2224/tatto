import 'package:flutter/material.dart';
import 'package:tato/utils/colors.dart';

class Loading extends StatelessWidget {
  double height ;
  double width ;
  bool isBackground ;


  Loading({this.height = 50, this.width = 50 , this.isBackground = true });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.height,
        height: this.width,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isBackground ? PRIMARY_COLOR : Colors.white,
          shape: BoxShape.circle
        ),
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(this.isBackground ? Colors.white : PRIMARY_COLOR),
        ),
      ),
    );
  }
}
