import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ccms_des/ccms_des.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _string = "testMessage";
  final _key = "12345678";

  var _encrytString;
  var _decrytString;

  @override
  void initState() {
    super.initState();
    example();
  }

  Future<void> example() async {
    _encrytString = await CcmsDes.encryptToHex(_string, _key);
    _decrytString = await CcmsDes.decryptFromHex(_encrytString, _key);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('des example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              Text('_string : $_string'),
              Text('_key : $_key'),
              Padding(padding: EdgeInsets.all(10)),
              Text('encrytString : $_encrytString'),
              Text('decrytString : $_decrytString'),
            ],
          ),
        ),
      ),
    );
  }
}
