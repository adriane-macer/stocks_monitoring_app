import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_monitoring_app/constants/app_constants.dart';
import 'package:stock_monitoring_app/stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../company.dart';

class StockModel extends ChangeNotifier {
  bool isCandleStickChart = false;

  void toggleChart() {
    isCandleStickChart = !isCandleStickChart;
    notifyListeners();
  }

  Stream<List<Company>> getCompanies() async* {
    yield [];
    try {
      final http.Response response =
          await http.get("${AppConstants.BASE_URL}${AppConstants.STOCKS_PATH}");

      if (response.statusCode == 200) {
        yield (json.decode(response.body)["stocks"] as List)
            .map((data) => Company.fromJson(data))
            .where((Company company) => company.status == "OPEN")
            .toList();
      }
    } catch (e) {
      print(e);
      throw Exception("StockModel.getCompanies() exception: $e");
    }
  }

  Stream<List<Stock>> getCompanyStocks(String symbol,
      {String fromDate, String toDate}) async* {
    yield [];
    String recentDate;
    String firstDate;
    if (toDate == null) {
      recentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      // last 30 days
      firstDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 30)));
    } else {
      recentDate = toDate;
      if (fromDate == null) {
        // last 30 days
        firstDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.tryParse(recentDate).subtract(Duration(days: 30)));
      } else {
        firstDate = fromDate;
      }
    }

    try {
      final http.Response response = await http.get(
          "${AppConstants.BASE_URL}${AppConstants.STOCKS_PATH}/$symbol/history/$firstDate/$recentDate");
      if (response.statusCode == 200) {
        yield (json.decode(response.body)["history"] as List)
            .map((data) => Stock.fromJson(data))
            .toList();
      }
    } catch (e) {
      print(e);
      throw Exception("StockModel.getCompanyStocks() exception: $e");
    }
  }
}
