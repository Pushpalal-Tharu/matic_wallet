import 'package:matic_wallet/model/chain_model.dart';

class WalletModel {
  String? name;
  String? publicAddress;
  String? mnemonic;
  String? privateKey;
  List<ChainModel> chains = [];

  WalletModel({
    this.name,
    this.publicAddress,
    this.mnemonic,
    this.privateKey,
    this.chains = const [],
  });

  WalletModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    publicAddress = json['publicAddress'];
    mnemonic = json['mnemonic'];
    privateKey = json['privateKey'];
    chains = [];
    if (json['chains'] != null) {
      chains = <ChainModel>[];
      json['chains'].forEach((v) {
        chains.add(ChainModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['publicAddress'] = publicAddress;
    data['mnemonic'] = mnemonic;
    data['privateKey'] = privateKey;
    data['chains'] = chains.map((e) => e.toJson()).toList();
    return data;
  }
}
