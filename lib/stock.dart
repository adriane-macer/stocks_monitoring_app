class Stock {
  // final String symbol;
  final String date;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  Stock(
      {
        // this.symbol,
      this.date,
      this.open,
      this.high,
      this.low,
      this.close,
      this.volume});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        // symbol: json['symbol'],
        date: json['trading_date'],
        open: json['open'],
        high: json['high'],
        low: json['low'],
        close: json['close'],
        volume: json['volume']);
  }
}
