import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tato/data/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/sent/AuthModel.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance ;
Future<bool> setUserData({@required User data})async{
  await setToken(token: data.token);
  await setId(userId: data.id);
  return true ;
}

 Future<void> logout(BuildContext context)async{
   SharedPreferences _prefs =  await SharedPreferences.getInstance();
   _prefs.clear();
 }
Future<bool> setToken({@required String token }) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString("token", "Bearer $token");
  return true;
}

Future<String> getToken() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String token = _prefs.getString("token")??null;
  return token;
}

Future<bool> setId({@required int userId}) async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();
   _prefs.setInt("userId", userId);
  return true;
}

Future<int> getUserId() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  int userId = _prefs.getInt("userId")??-1;
  return userId;
}

saveFireBaseToken(){
  if (Platform.isIOS) iOS_Permission();
  _firebaseMessaging.getToken().then((value) => ApiProvider.saveToken(FCMtoken: value));
  _firebaseMessaging.subscribeToTopic("users");
}
void iOS_Permission() async {
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}








