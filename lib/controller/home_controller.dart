import 'package:matic_wallet/data/repository/account_repository.dart';
import 'package:matic_wallet/data/repository/chain_repository.dart';
import 'package:matic_wallet/model/chain_model.dart';
import 'package:matic_wallet/model/wallet_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  bool isInitializing = true;

  List<WalletModel> wallets = [];

  int currentActiveWalletIndex = 0;
  int currentActiveChainIndex = 0;

  String? currentActiveChainHistoryUrl;

  WalletModel get currentActiveWallet => wallets[currentActiveWalletIndex];
  ChainModel get currentActiveChain =>
      wallets[currentActiveWalletIndex].chains[currentActiveChainIndex];

  double nativeBalance = 0;
  String message = "";

  Map<String, String> contractToBalance = {};

  @override
  void onInit() {
    super.onInit();
    wallets = [];
    currentActiveChainIndex = 0;
    currentActiveWalletIndex = 0;
    initialize();
  }

  Future<void> initialize() async {
    await fetchWallets();
    isInitializing = false;
    update();
  }

  Future<void> fetchWallets() async {
    List<WalletModel> accounts = AccountRepository.fetchWallet();
    wallets = accounts;
    currentActiveWalletIndex = 0;
    currentActiveChainIndex = 0;
    update();
    fetchBalanceFromChain();
  }

  Future<void> fetchBalanceFromChain() async {
    // Getting Native Balance
    nativeBalance = await ChainRepository.fetchBalanceFromChain(
        wallets[currentActiveWalletIndex].privateKey!,
        wallets[currentActiveWalletIndex].chains[currentActiveChainIndex]);
    update();
  }

  Future<void> handleSelectNetwork(ChainModel chain) async {
    Get.back();
    int index = wallets[currentActiveWalletIndex].chains.indexWhere(
          (ChainModel item) => item.chainId == chain.chainId,
        );
    currentActiveChainIndex = index;
    nativeBalance = 0;
    update();
    fetchBalanceFromChain();
  }
}
