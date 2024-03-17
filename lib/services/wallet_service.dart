import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:matic_wallet/data/repository/account_repository.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletService {
  static String generateMnemonic() {
    String mnemonic = bip39.generateMnemonic();
    GetStorage storage = GetStorage();
    storage.write("mnemonic", mnemonic);
    const secureStorage = FlutterSecureStorage();
    secureStorage.write(key: 'mnemonic', value: mnemonic);
    return mnemonic;
  }

  static Future<String> generatePrivateKey(String mnemonic) async {
    const secureStorage = FlutterSecureStorage();
    secureStorage.write(key: 'mnemonic', value: mnemonic);
    final seed = bip39.mnemonicToSeed(mnemonic);
    final node = bip32.BIP32.fromSeed(seed);
    final child = node.derivePath("m/44'/60'/0'/0/0");
    final String privateKey = HEX.encode(child.privateKey!);
    return privateKey;
  }

  static EthereumAddress generatePublicKey(String privateKey) {
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    return credentials.address;
  }

  static Future<void> addWallet(String mnemonic) async {
    String privateKey = await WalletService.generatePrivateKey(mnemonic);
    String publicKey = WalletService.generatePublicKey(privateKey).hex;
    AccountRepository.saveWallet(
      mnemonic: mnemonic,
      publicAddress: publicKey,
      privateKey: privateKey,
    );
  }
}
