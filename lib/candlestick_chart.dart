import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:stock_monitoring_app/stock.dart';

class CandlestickChart extends StatelessWidget {
  final List<Stock> stocks;

  const CandlestickChart({
    Key key,
    @required this.stocks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 36.0),
      child: OHLCVGraph(
        data: _stockData(),
        enableGridLines: false,
        volumeProp: 0.2,
      ),
    );
  }

  List<Map<String, double>> _stockData() {
    final List<Map<String, double>> stockData = [];
    stocks.forEach((Stock stock) {
      stockData.add({
        "open": stock.open,
        "high": stock.high,
        "low": stock.low,
        "close": stock.close,
        "volumeto": stock.volume
      });
    });
    return stockData;
  }
}
