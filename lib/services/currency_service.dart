import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exchange_rate.dart';
import 'package:flutter/services.dart';

class CurrencyService {
  static const MethodChannel _channel =
  MethodChannel('app.channel.api.data');

  static Future<String> getApiKey() async {
    try {
      final key = await _channel.invokeMethod('getCurrencyApiKey');
      if (key == null || key.isEmpty) {
        throw Exception('API key not available');
      }
      return key;
    } on PlatformException catch (e) {
      throw Exception('Failed to get API key: ${e.message}');
    }
  }

  static const String _baseUrl = 'https://api.freecurrencyapi.com/v1/latest';

  Future<ExchangeRate> getExchangeRate(String fromCurrency, String toCurrency) async {
    final key = await getApiKey();
    final response = await http.get(
      Uri.parse('$_baseUrl?apikey=$key&base_currency=$fromCurrency&currencies=$toCurrency'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] == null || data['data'][toCurrency] == null) {
        throw Exception('Invalid API response format');
      }
      return ExchangeRate(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        rate: data['data'][toCurrency].toDouble(),
        lastUpdated: DateTime.now(),
      );
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}