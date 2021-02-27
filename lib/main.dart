import 'package:flutter/material.dart';
import 'package:stock_monitoring_app/model/stock_model.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StockModel>(create: (_) => StockModel()),
      ],
      child: MaterialApp(
        title: 'PSE Stock Monitoring',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
