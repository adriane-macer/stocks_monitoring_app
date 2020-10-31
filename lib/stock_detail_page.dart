import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_monitoring_app/stock.dart';
import 'package:stock_monitoring_app/stock_chart.dart';

import 'company.dart';
import 'constants.dart';

class StockDetailPage extends StatefulWidget {
  final Company company;

  const StockDetailPage({Key key, @required this.company}) : super(key: key);

  @override
  _StockDetailPageState createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company.symbol),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Spread the width to it's parent's width
          SizedBox(
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.company.companyName}",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          FutureBuilder(
            future: getStocks(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Stock>> snapshot) {
              if (snapshot.hasData) {
                final List<Stock> stocks = snapshot.data;
                if (stocks.isNotEmpty) {
                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Records from ${stocks[0].date} to ${stocks[stocks.length - 1].date}"),
                        ),
                        Expanded(
                          child: StockChart(
                            stocks: stocks,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: stocks.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Text(
                                          "${stocks[index].date.toString()}"),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Open: ",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                  Text(
                                                    "${stocks[index].open}",
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Low: ",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  Text(
                                                    "${stocks[index].low}",
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Close: ",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                  Text(
                                                    "${stocks[index].close}",
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "High: ",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                  Text(
                                                    "${stocks[index].high}",
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return Center(
                  child: Text("Fetch error."),
                );
              }
              return Center(child: Text("No Data"));
            },
          )
        ],
      ),
    );
  }

  Future<List<Stock>> getStocks() async {
    try {
      final http.Response response = await http
          .get("${Constants.BASE_URL}/Stock/${widget.company.symbol}");

      if (response.statusCode == 200) {
        return (json.decode(response.body) as List)
            .map((data) => Stock.fromJson(data))
            .toList();
      }
    } catch (e) {
      print(e);
      throw Exception("StockDetailPage.getStocks() exception: $e");
    }
    return [];
  }
}
