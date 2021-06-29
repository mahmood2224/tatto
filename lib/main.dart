import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:tato/ui/views/splash_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      EasyLocalization(
        child:  MyApp(),
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('ar', 'SA'), // Arabic
        ],
        path: 'assets/lang',
        saveLocale: true,
        startLocale:  const Locale('ar', 'SA'),
      )
  );
}

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    log(EasyLocalization.of(context).locale.toString(),
        name: '${this} # locale');
    log('title'.tr().toString(), name: '${this} # locale');



    return StyledToast(
      locale: const Locale('ar', 'SA'),
      textStyle: TextStyle(fontSize: 16.0, color: Colors.white), //Default text style of toast
      backgroundColor: Color(0x99000000),  //Background color of toast
      borderRadius: BorderRadius.circular(5.0), //Border radius of toast
      textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),//The padding of toast text
      toastPositions: StyledToastPosition.bottom, //The position of toast
      toastAnimation: StyledToastAnimation.fade,  //The animation type of toast
      reverseAnimation: StyledToastAnimation.fade, //The reverse animation of toast (display When dismiss toast)
      curve: Curves.fastOutSlowIn,  //The curve of animation
      reverseCurve: Curves.fastLinearToSlowEaseIn, //The curve of reverse animation
      duration: Duration(seconds: 4), //The duration of toast showing
      animDuration: Duration(seconds: 1), //The duration of animation(including reverse) of toast
      dismissOtherOnShow: true,  //When we show a toast and other toast is showing, dismiss any other showing toast before.
      fullWidth: false,
      child: GestureDetector(
        onTap: (){
          FocusScopeNode scope = FocusScope.of(context);
          if(!scope.hasPrimaryFocus)
            FocusScope.of(context).requestFocus(new FocusNode());

        },
        child: MaterialApp(
          title: 'title'.tr(),
          localizationsDelegates:EasyLocalization.of(context).delegates,
          supportedLocales: EasyLocalization.of(context).supportedLocales,
          locale: EasyLocalization.of(context).locale,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: "Cairo",
          ),
          home: SplashScreen(),
        ),

      ),
    );
  }
}
