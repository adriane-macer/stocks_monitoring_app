class Company {
  final symbol;
  final companyName;

  Company({
    this.symbol,
    this.companyName
  });

  factory Company.fromJson(Map<String, dynamic> json){
    return Company(
      symbol: json['stock_symbol'],
      companyName: json['company_name']
    );
  }
}