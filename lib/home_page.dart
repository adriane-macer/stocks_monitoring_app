
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_monitoring_app/model/stock_model.dart';
import 'package:stock_monitoring_app/stock_detail_page.dart';
import 'package:provider/provider.dart';

import 'company.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Stocks Monitoring"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: context.read<StockModel>().getCompanies(),
        builder: (BuildContext context, AsyncSnapshot<List<Company>> snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.isEmpty){
              return Center(
                child: Text("No data.",
                    style: Theme.of(context).textTheme.bodyText2),
              );
            }
            final companies = snapshot.data;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StockDetailPage(
                              company: companies[index],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(companies[index].symbol),
                            subtitle: Text(companies[index].companyName),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Center(
              child: Text("Fetch Error",
                  style: Theme.of(context).textTheme.bodyText2),
            );
          }
          return Center(
            child: Text("No data.",
                style: Theme.of(context).textTheme.bodyText2),
          );
        },
      ),
    );
  }
}
