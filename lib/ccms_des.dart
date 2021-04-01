import 'dart:async';

import 'package:flutter/services.dart';

class CcmsDes {
  static const MethodChannel _channel = const MethodChannel('ccms_des');

  static Future<String> encryptToHex(String string, String key) async {
    if (string.isEmpty || key.isEmpty) {
      return '';
    }
    final String encryString = await _channel.invokeMethod('encryptToHex', [string, key]);
    return encryString;
  }

  static Future<String> decryptFromHex(String hex, String key) async {
    if (hex.isEmpty || key.isEmpty) {
      return '';
    }
    final String decryString = await _channel.invokeMethod('decryptFromHex', [hex, key]);
    return decryString;
  }
}
