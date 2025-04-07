class ExchangeRate {
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime lastUpdated;

  ExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.lastUpdated,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json, String fromCurrency, String toCurrency) {
    return ExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      rate: json['data'][toCurrency]?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(json['meta']['last_updated_at'] ?? DateTime.now().toString()),
    );
  }
}