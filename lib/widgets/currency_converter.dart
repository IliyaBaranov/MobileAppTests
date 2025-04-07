import 'package:flutter/material.dart';
import '../models/exchange_rate.dart';
import 'currency_selector.dart';

class CurrencyConverter extends StatefulWidget {
  final VoidCallback onSwapCurrencies;
  final ExchangeRate? exchangeRate;
  final VoidCallback onRefresh;
  final Function(String, String) onCurrencyPairChanged;


  const CurrencyConverter({
    this.exchangeRate,
    required this.onRefresh,
    required this.onCurrencyPairChanged,
    required this.onSwapCurrencies,
    super.key,
  });

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _amountController = TextEditingController();
  final List<String> _currencies = ['EUR', 'USD', 'GBP', 'JPY', 'CAD', 'AUD'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Currency Converter',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: widget.onSwapCurrencies,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _convert(),
                ),
              ),
              const SizedBox(width: 10),
              CurrencySelector(
                value: widget.exchangeRate?.toCurrency ?? 'USD',
                currencies: _currencies,
                onChanged: (newCurrency) {
                  if (newCurrency != null) {
                    widget.onCurrencyPairChanged(
                      widget.exchangeRate?.fromCurrency ?? 'EUR',
                      newCurrency,
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.swap_vert),
                onPressed: () {
                  final from = widget.exchangeRate?.fromCurrency ?? 'EUR';
                  final to = widget.exchangeRate?.toCurrency ?? 'USD';
                  widget.onCurrencyPairChanged(to, from);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Converted Amount',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: _getConvertedAmount(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CurrencySelector(
                value: widget.exchangeRate?.fromCurrency ?? 'EUR',
                currencies: _currencies,
                onChanged: (newCurrency) {
                  if (newCurrency != null) {
                    widget.onCurrencyPairChanged(
                      newCurrency,
                      widget.exchangeRate?.toCurrency ?? 'USD',
                    );
                  }
                },
              ),

            ],
          ),
          const SizedBox(height: 20),
          if (widget.exchangeRate != null)
            Text(
              '1 ${widget.exchangeRate!.fromCurrency} = ${widget.exchangeRate!.rate} ${widget.exchangeRate!.toCurrency}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          if (widget.exchangeRate != null)
            Text(
              'Last updated: ${widget.exchangeRate!.lastUpdated.toString().substring(0, 19)}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  String _getConvertedAmount() {
    if (widget.exchangeRate == null || _amountController.text.isEmpty) {
      return '';
    }

    final amount = double.tryParse(_amountController.text) ?? 0;
    final from = widget.exchangeRate!.fromCurrency;
    final to = widget.exchangeRate!.toCurrency;
    final rate = widget.exchangeRate!.rate;

    // Always assume user enters FROM amount, convert to TO
    return (amount * rate).toStringAsFixed(2);
  }


  void _convert() {
    setState(() {});
  }
}