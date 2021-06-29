import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum MessageType { SUCCESS, ERROR }
void showInSnackBar(
    {@required String value,
    @required GlobalKey<ScaffoldState> scaffoldKey,
    MessageType messageType}) {
  FocusScope.of(scaffoldKey.currentContext).requestFocus(new FocusNode());

  scaffoldKey.currentState?.removeCurrentSnackBar();
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontSize: 14.0 ),
    ),
    backgroundColor:
        messageType == MessageType.SUCCESS ? Colors.green : Colors.red,
    duration: Duration(seconds: 3),
  ));
}
