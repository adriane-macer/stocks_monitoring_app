
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock Monitoring"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: context.read<StockModel>().getCompanies(),
//        initialData: <Stock>[],
        builder: (BuildContext context, AsyncSnapshot<List<Company>> snapshot) {
          if (snapshot.hasData) {
            final companies = snapshot.data;
            return ListView.builder(
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
                });
          } else if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Center(
              child: Text("Fetch Error"),
            );
          }
          return Center(
            child: Text("No data."),
          );
        },
      ),
    );
  }

  // Future<List<Company>> getCompanies() async {
  //   // Because the API does not provide the list of the companies,
  //   // they were listed manually.
  //   final jsonString = await rootBundle.loadString(Constants.COMPANY_JSON_FILE);
  //   final jsonResponse = jsonDecode(jsonString);
  //
  //   dynamic companies;
  //   try {
  //     companies = jsonResponse
  //         .map((data) => Company.fromJson(data as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     debugPrint(e);
  //     throw Exception("HomePage.getCompanies() exception: $e");
  //   }
  //   final List<Company> companyList = [];
  //   companies.forEach((company) {
  //     companyList.add(Company(
  //         symbol: company.symbol.toString(),
  //         companyName: company.companyName.toString()));
  //   });
  //   return companyList;
  // }
}
