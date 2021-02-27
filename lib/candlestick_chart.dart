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
    return OHLCVGraph(
      data: _stockData(),
      enableGridLines: false,
      volumeProp: 0.2,
    );
  }

  List<Map<String, double>> _stockData() {
    final List<Map<String, double>> stockData = [];

    DateTime previousDateTime;
    Stock previousStock;
    for (int i = 0; i < stocks.length; i++) {
      if (i == 0) {
        stockData.add({
          "open": stocks[i].open,
          "high": stocks[i].high,
          "low": stocks[i].low,
          "close": stocks[i].close,
          "volumeto": stocks[i].volume
        });
      } else {
        DateTime currentDate = DateTime.tryParse(stocks[i].date);
        final dayDiffer = currentDate.difference(previousDateTime).inDays;
        if( dayDiffer > 1) {
          // handles no trading days
          for(int d = 1 ; d<dayDiffer;++d){
            stockData.add({
              "open": previousStock.close,
              "high": previousStock.close,
              "low": previousStock.close,
              "close": previousStock.close,
              "volumeto": 0.0
            });
          }
        }else{
          stockData.add({
            "open": stocks[i].open,
            "high": stocks[i].high,
            "low": stocks[i].low,
            "close": stocks[i].close,
            "volumeto": stocks[i].volume
          });
        }
      }
      previousDateTime = DateTime.tryParse(stocks[i].date);
      previousStock = stocks[i];
    }

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
