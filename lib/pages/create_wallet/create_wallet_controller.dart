import 'package:matic_wallet/pages/mnemonic_verification/mnemonic_verification_page.dart';
import 'package:matic_wallet/services/wallet_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreateWalletController extends GetxController {
  final String mnemonic = WalletService.generateMnemonic();

  void handleCopyToClipboardClick() {
    Clipboard.setData(ClipboardData(text: mnemonic));
    Get.snackbar(
      "Success",
      "Mnemonic copied to Clipboard",
      snackPosition: SnackPosition.TOP,
    );
    Get.to(() => MnemonicVerificationPage(mnemonic: mnemonic));
  }
}
