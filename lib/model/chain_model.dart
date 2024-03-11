import 'package:matic_wallet/model/token_model.dart';

class ChainModel {
  String? name;
  String? rpcUrl;
  String? chainId;
  String? symbol;
  double balance = 0;
  List<TokenModel> tokens = [];

  ChainModel({
    this.name,
    this.rpcUrl,
    this.chainId,
    this.symbol,
    this.balance = 0,
    this.tokens = const [],
  });

  ChainModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rpcUrl = json['rpcUrl'];
    chainId = json['chainId'];
    symbol = json['symbol'];
    balance = json['balance'] ?? 0;
    if (json['tokens'] != null) {
      tokens = <TokenModel>[];
      json['tokens'].forEach((v) {
        tokens.add(TokenModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['rpcUrl'] = rpcUrl;
    data['chainId'] = chainId;
    data['balance'] = balance;
    data['symbol'] = symbol;
    data['tokens'] = tokens
        .map(
          (e) => e.toJson(),
        )
        .toList();
    return data;
  }
}
