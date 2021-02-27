class Company {
  final symbol;
  final companyName;
  final status;

  Company({
    this.symbol,
    this.companyName,
    this.status,
  });

  factory Company.fromJson(Map<String, dynamic> json){
    return Company(
      symbol: json['ticker_symbol'],
      companyName: json['company_name'],
      status: json['status']
    );
  }
}