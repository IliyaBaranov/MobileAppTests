import 'package:flutter/services.dart';

class NativeApiKeyLoader {
  static const MethodChannel _channel = MethodChannel('app.channel.api.data');

  static Future<String> getCurrencyApiKey() async {
    try {
      return await _channel.invokeMethod('getCurrencyApiKey');
    } on PlatformException catch (e) {
      print("Failed to get API key: '${e.message}'.");
      return '';
    }
  }
}