import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_monitoring_app/candlestick_chart.dart';
import 'package:stock_monitoring_app/stock.dart';
import 'package:stock_monitoring_app/stock_chart.dart';

import 'model/stock_model.dart';

class ChartView extends StatelessWidget {
  final List<Stock> stocks;

  const ChartView({Key key, this.stocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCandleStickChart =
        context.watch<StockModel>().isCandleStickChart;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              color: isCandleStickChart ? Colors.white24 : Colors.white,
            ),
            Switch(
              onChanged: (bool value) {
                context.read<StockModel>().toggleChart();
              },
              activeColor: Colors.white,
              inactiveTrackColor: Colors.white24,
              activeTrackColor: Colors.white24,
              value: isCandleStickChart,
            ),
            Icon(
              Icons.bar_chart,
              color: isCandleStickChart ? Colors.white : Colors.white24,
            )
          ],
        ),
        Expanded(
            child: isCandleStickChart
                ? CandlestickChart(stocks: stocks)
                : StockChart(stocks: stocks))
      ],
    );
  }
}
