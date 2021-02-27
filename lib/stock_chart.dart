import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stock_monitoring_app/stock.dart';

class StockChart extends StatefulWidget {
  final List<Stock> stocks;

  const StockChart({Key key, @required this.stocks}) : super(key: key);

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  double minY = 0;
  double maxY = 0;
  double minX = 0;
  double maxX = 0;

  List<_SpotStock> spotStocks = [];

  @override
  void initState() {
    super.initState();
    calculateMinMax();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          // gradient: LinearGradient(
            // colors: [
            //   // Color(0xff2c274c),
            //   // Color(0xff46426c),
            // ],
            // begin: Alignment.bottomCenter,
            // end: Alignment.topCenter,
          // ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      stockChartData(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData stockChartData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            return value.toString();
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: minX,
      maxX: maxX,
      maxY: maxY,
      minY: minY,
      lineBarsData: linesBarData(),
    );
  }

  List<LineChartBarData> linesBarData() {
    return [
      LineChartBarData(
        spots: [
          for (_SpotStock spotStock in spotStocks)
            FlSpot(spotStock.x, spotStock.stock.close)
        ],
        isCurved: false,
        colors: [
          const Color(0xff4af699),
        ],
        barWidth: 4,
        isStrokeCapRound: false,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      )
    ];
  }

  void calculateMinMax() {
    if (widget.stocks.length <= 0) {
      return;
    } else if (widget.stocks.length == 1) {
      minY = widget.stocks.first.close.floor() - 1.0;
      maxY = widget.stocks.first.close.ceil() + 1.0;

      maxX = 3;
      minX = 0;
      // Put the data in the horizontal center
      spotStocks.add(_SpotStock(1, widget.stocks.first));
      return;
    }

    List<Stock> stocks = [];
    stocks.addAll(widget.stocks);
    // vertical axis min max
    stocks.sort((a, b) => a.close.compareTo(b.close));
    minY = stocks.first.close.floor().toDouble();
    maxY = stocks.last.close.ceil().toDouble();

    // horizontal axis
    int position = 0;
    print(widget.stocks.length);
    for (int i = 0; i < widget.stocks.length; i++) {
      print("i = $i");
      if (i == 0) {
        spotStocks.add(_SpotStock(i.toDouble(), widget.stocks[i]));
      } else {
        DateTime previousDate = DateTime.tryParse(widget.stocks[i - 1].date);
        DateTime currentDate = DateTime.tryParse(widget.stocks[i].date);
        // handles no trading days
        int difference = currentDate.difference(previousDate).inDays;
        position += difference;
        spotStocks.add(_SpotStock(position.toDouble(), widget.stocks[i]));
      }
    }
    maxX = position.toDouble();
  }

  String convertedDateString(String dateFromApiFormat) {
    // The date format from api is MM/DD/YYYY
    // The nearest format that the DateTime is YYYYMMDD
    List<String> splitDate = dateFromApiFormat.toString().split("/");
    return "${splitDate.last}${splitDate.first.toString().padLeft(2, "0")}${splitDate[1].toString().padLeft(2, "0")}";
  }
}

class _SpotStock {
  final x;
  final Stock stock;

  _SpotStock(this.x, this.stock);
}
