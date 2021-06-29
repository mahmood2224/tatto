import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tato/data/api_provider.dart';
import 'package:tato/data/userData.dart';
import 'package:tato/ui/views/home.dart';
import 'package:tato/ui/views/product_gallary.dart';
import 'package:tato/utils/Dialog.dart';
import 'package:tato/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {

  Timer _timer;
  @override
  void initState() {
    super.initState();
    bindColor();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }



  _login(){
    ApiProvider.login(onError: (){} , onSuccess: ()=>     Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (
        route) => false) );
  }

  _getColor(){
    ApiProvider.getColorFromServer( onSuccess: (){
      bindColor();
      _login();
    });
  }

  @override
  Widget build(BuildContext context) {
    _timer = new Timer(Duration(milliseconds: 500), ()async {
     _getColor();
    });
    double width = MediaQuery.of(context).size.width ;
    double height= MediaQuery.of(context).size.height ;
    return Container(
      width: width,
      height: height,
      child: Image.asset('assets/images/splash_screen.png' ,fit: BoxFit.fill,),
    ) ;
  }
}