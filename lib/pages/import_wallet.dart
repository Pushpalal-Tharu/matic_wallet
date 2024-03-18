import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:matic_wallet/main.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:matic_wallet/services/wallet_service.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});
  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  // String mnemonic = '';
  // late List<String> seedPhrase;

  final _formKey = GlobalKey<FormState>();
  final _words = List<String>.filled(12, '');
  bool validationFailed = false;

  GetStorage secureStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import from seed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const Text('Please enter your recovery phrase',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 24.0),
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: GridView.count(
                          padding: const EdgeInsets.all(3),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 3,
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: List.generate(12, (index) {
                            return SizedBox(
                              height: 50,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: '${index + 1}',
                                ),
                                onSaved: (value) {
                                  _words[index] = value!;
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Text(validationFailed ? 'Invalid keyphrase' : '',
                        style: const TextStyle(color: Colors.red)),
                    // TextField(
                    //   onChanged: (value) {
                    //     setState(() {
                    //       mnemonic = value.trim();
                    //     });
                    //   },
                    //   decoration: const InputDecoration(
                    //     labelText: 'Enter mnemonic phrase',
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // verifyMnemonic();
                _onSubmit(context);
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

  void _onSubmit(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("****");
      print(_words);
      print("****");
      String wordsString = _words.join(' ');
      print(wordsString);
      print("****");
      final t = bip39.validateMnemonic(wordsString);
      if (t) {
        secureStorage.write('mnemonic', wordsString);
        await WalletService.addWallet(wordsString);
        navigateToWalletPage();
      } else {
        setState(() {
          validationFailed = true;
        });
      }
    }
  }

  // void verifyMnemonic() async {
  //   if (mnemonic == "") {
  //     Get.snackbar(
  //       "No mnemonic phrase",
  //       "Please enter the mnemonic phrase.",
  //       snackPosition: SnackPosition.TOP,
  //     );
  //   } else {
  //     mnemonic = removeMultipleSpaces(mnemonic);
  //     seedPhrase = mnemonic.split(' ');
  //     if (seedPhrase.length == 12) {
  //       await WalletService.addWallet(mnemonic);
  //       navigateToWalletPage();
  //     } else if (seedPhrase.length < 12) {
  //       Get.snackbar(
  //         "Mnemonic phrase incomplete",
  //         "Please enter the 12 words phrase.",
  //         snackPosition: SnackPosition.TOP,
  //       );
  //     } else {
  //       Get.snackbar(
  //         "Mnemonic phrase incomplete",
  //         "Entered mnemonic phrase must not be greater than 12.",
  //         snackPosition: SnackPosition.TOP,
  //       );
  //     }
  //   }
  // }

  // // Define a function that removes multiple spaces from a string
  // String removeMultipleSpaces(String input) {
  //   // Create a RegExp object with the pattern r"\s+"
  //   RegExp whitespaceRE = RegExp(r"\s+");

  //   // Replace all the white space characters with a single space
  //   String output = input.replaceAll(whitespaceRE, " ");

  //   // Return the resulting string
  //   return output;
  // }

  void navigateToWalletPage() {
    Get.to(const MainPage());
  }
}
