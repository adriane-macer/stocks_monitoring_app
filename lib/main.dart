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
        theme:  ThemeData(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(
              elevation: 0.0,
              color: Colors.black,
              brightness: Brightness.dark,
            ),
            iconTheme: const IconThemeData(color: Colors.black, size: 40.0),

            textTheme: const TextTheme(
              headline1: TextStyle(
                color: Colors.white,
              ),
              headline2: TextStyle(
                color: Colors.white,
              ),
              headline3: TextStyle(
                color: Colors.white,
              ),
              headline4: TextStyle(
                color: Colors.white,
              ),
              headline5: TextStyle(
                color: Colors.white,
              ),
              headline6: TextStyle(
                color: Colors.white,
              ),
              bodyText1: TextStyle(
                color: Colors.white,
              ),
              bodyText2: TextStyle(
                color: Colors.white,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
