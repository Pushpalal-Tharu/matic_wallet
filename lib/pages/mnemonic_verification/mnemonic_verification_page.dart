import 'package:matic_wallet/main.dart';
import 'package:matic_wallet/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MnemonicVerificationPage extends StatefulWidget {
  final String mnemonic;
  const MnemonicVerificationPage({super.key, required this.mnemonic});

  @override
  State<MnemonicVerificationPage> createState() =>
      _MnemonicVerificationPageState();
}

class _MnemonicVerificationPageState extends State<MnemonicVerificationPage> {
  bool isVerified = false;
  String verificationText = "";

  void verifyMnemonic() {
    if (verificationText.trim() == widget.mnemonic.trim()) {
      setState(() {
        isVerified = true;
      });
    }
  }

  void navigateToWalletPage() async {
    await WalletService.addWallet(verificationText);
    Get.to(() => const MainPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify and Create'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Please verify your mnemonic phrase:-',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 24.0),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          verificationText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter mnemonic phrase.',
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                verifyMnemonic();
                setState(() {
                  if (isVerified) {
                    navigateToWalletPage();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 71, 10, 177), // Customize button background color
                foregroundColor: Colors.white, // Customize button text color
              ),
              child: isVerified ? const Text('Next') : const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
