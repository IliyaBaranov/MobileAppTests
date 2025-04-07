import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/exchange_rate.dart';
import 'services/currency_service.dart';
import 'widgets/currency_converter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({Key? key}) : super(key: key);

  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final CurrencyService _currencyService = CurrencyService();
  ExchangeRate? _exchangeRate;
  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _fetchExchangeRate();
  }

  Future<void> _fetchExchangeRate() async {
    try {
      final rate = await _currencyService.getExchangeRate(_fromCurrency, _toCurrency);
      setState(() {
        _exchangeRate = rate;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
      print('Error fetching rate: $e');
    }
  }

  void _handleCurrencyPairChanged(String from, String to) {
    setState(() {
      _fromCurrency = from;
      _toCurrency = to;
    });
    _fetchExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchExchangeRate,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: CurrencyConverter(
            exchangeRate: _exchangeRate,
            onRefresh: _fetchExchangeRate,
            onCurrencyPairChanged: _handleCurrencyPairChanged,
          ),
        ),
      ),
    );
  }
}