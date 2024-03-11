class TokenModel {
  String? name;
  String? contract;
  String? symbol;
  String? decimal;

  TokenModel({this.name, this.contract, this.symbol, this.decimal});

  TokenModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contract = json['contract'];
    symbol = json['symbol'];
    decimal = json['decimal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['contract'] = contract;
    data['symbol'] = symbol;
    data['decimal'] = decimal;
    return data;
  }
}
