import 'package:matic_wallet/pages/create_wallet/create_wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({super.key});

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateWalletController>(
      init: CreateWalletController(),
      builder: (CreateWalletController controller) {
        List<String> mnemonicWords = controller.mnemonic.split(" ");
        return Scaffold(
          appBar: AppBar(
            title: const Text("Generate Mnemonic"),
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
                        'Please store this mnemonic phrase safely:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          mnemonicWords.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              '${index + 1}. ${mnemonicWords[index]}',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.handleCopyToClipboardClick();
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy to Clipboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 71, 10, 177), // Customize button background color
                    foregroundColor:
                        Colors.white, // Customize button text color
                  ),
                ),
                const SizedBox(height: 6.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
