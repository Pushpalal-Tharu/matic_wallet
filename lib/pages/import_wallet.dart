import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matic_wallet/pages/home/home_page.dart';
import 'package:matic_wallet/services/wallet_service.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});
  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  String mnemonic = '';
  late List<String> seedPhrase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import from Seed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Please Enter your mnemonic phrase:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 24.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        mnemonic = value.trim();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter mnemonic phrase',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                verifyMnemonic();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 71, 10, 177), // Customize button background color
                foregroundColor: Colors.white, // Customize button text color
              ),
              child: const Text("Import"),
            ),
            const SizedBox(height: 6.0),
          ],
        ),
      ),
    );
  }

  void verifyMnemonic() async {
    if (mnemonic == "") {
      Get.snackbar(
        "No mnemonic phrase",
        "Please enter the mnemonic phrase.",
        snackPosition: SnackPosition.TOP,
      );
    } else {
      mnemonic = removeMultipleSpaces(mnemonic);
      seedPhrase = mnemonic.split(' ');
      if (seedPhrase.length == 12) {
        await WalletService.addWallet(mnemonic);
        navigateToWalletPage();
      } else if (seedPhrase.length < 12) {
        Get.snackbar(
          "Mnemonic phrase incomplete",
          "Please enter the 12 words phrase.",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Mnemonic phrase incomplete",
          "Entered mnemonic phrase must not be greater than 12.",
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  // Define a function that removes multiple spaces from a string
  String removeMultipleSpaces(String input) {
    // Create a RegExp object with the pattern r"\s+"
    RegExp whitespaceRE = RegExp(r"\s+");

    // Replace all the white space characters with a single space
    String output = input.replaceAll(whitespaceRE, " ");

    // Return the resulting string
    return output;
  }

  void navigateToWalletPage() {
    Get.to(const HomePage());
  }
}
