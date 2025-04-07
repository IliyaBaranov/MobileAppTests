import 'package:flutter/material.dart';

class CurrencySelector extends StatelessWidget {
  final String value;
  final List<String> currencies;
  final ValueChanged<String?>? onChanged;

  const CurrencySelector({
    required this.value,
    required this.currencies,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: currencies.map((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}