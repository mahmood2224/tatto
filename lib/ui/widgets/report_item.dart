import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:flutter/cupertino.dart';
class ReportBAckGround extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint_0 = new Paint()
      ..color = Color.fromARGB(255, 249, 249, 249)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path_0 = Path();
    path_0.moveTo(size.width*0.25,size.height*0.13);
    path_0.lineTo(size.width*0.58,size.height*0.13);
    path_0.lineTo(size.width*0.58,size.height*0.27);
    path_0.quadraticBezierTo(size.width*0.54,size.height*0.27,size.width*0.54,size.height*0.32);
    path_0.quadraticBezierTo(size.width*0.54,size.height*0.34,size.width*0.58,size.height*0.34);
    path_0.lineTo(size.width*0.58,size.height*0.49);
    path_0.lineTo(size.width*0.25,size.height*0.49);
    path_0.lineTo(size.width*0.25,size.height*0.34);
    path_0.quadraticBezierTo(size.width*0.29,size.height*0.34,size.width*0.29,size.height*0.32);
    path_0.quadraticBezierTo(size.width*0.29,size.height*0.28,size.width*0.25,size.height*0.27);
    path_0.lineTo(size.width*0.25,size.height*0.13);
    path_0.close();

    canvas.drawPath(path_0, paint_0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class ItemBackground extends StatelessWidget {
  double width ;
  double height ;
  Widget child ;

  ItemBackground({this.width, this.height, this.child});

  @override
  Widget build(BuildContext context) {
    return  CustomPaint(
    size: Size(1200,700), //You can Replace this with your desired WIDTH and HEIGHT
    painter: ReportBAckGround(),
    );
  }
}

