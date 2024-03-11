import 'dart:convert';
import 'package:matic_wallet/data/constant/default_asset.dart';
import 'package:matic_wallet/model/wallet_model.dart';
import 'package:get_storage/get_storage.dart';

class AccountRepository {
  static List<WalletModel> fetchWallet() {
    GetStorage storage = GetStorage();
    dynamic accountsJsonString = storage.read("accounts");
    if (accountsJsonString == null) {
      return [];
    }
    List<dynamic> accountsMap = jsonDecode(accountsJsonString);
    List<WalletModel> accounts = accountsMap
        .map(
          (e) => WalletModel.fromJson(e),
        )
        .toList();
    return accounts;
  }

  static void saveWallet({
    mnemonic,
    publicAddress,
    privateKey,
  }) {
    List<WalletModel> accounts = fetchWallet();
    accounts.insert(
      0,
      WalletModel(
        mnemonic: mnemonic,
        publicAddress: publicAddress,
        privateKey: privateKey,
        chains: defaultChains,
      ),
    );
    List<Map<String, dynamic>> accountsJson =
        accounts.map((e) => e.toJson()).toList();
    GetStorage storage = GetStorage();
    storage.write("accounts", jsonEncode(accountsJson));
  }

  static void updateWholeWallet(List<WalletModel> wallets) {
    GetStorage storage = GetStorage();
    storage.remove("accounts");
    List<Map<String, dynamic>> accountsJson =
        wallets.map((e) => e.toJson()).toList();
    storage.write("accounts", jsonEncode(accountsJson));
  }

  static void removeWallet() {
    GetStorage storage = GetStorage();
    storage.erase();
  }
}
