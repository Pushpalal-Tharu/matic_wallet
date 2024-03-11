import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matic_wallet/controller/home_controller.dart';
import 'package:matic_wallet/data/repository/chain_repository.dart';
import 'package:matic_wallet/model/token_model.dart';
import 'package:web3dart/web3dart.dart';

class SendToken extends StatefulWidget {
  const SendToken({super.key});

  @override
  State<SendToken> createState() => _SendTokenState();
}

class _SendTokenState extends State<SendToken> {
  final textFieldDecoration = const InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(13)),
      borderSide: BorderSide(
        width: 2,
        color: Color(0xFF141414),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(13)),
      borderSide: BorderSide(
        width: 2,
        color: Color(0xFF141414),
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(13)),
      borderSide: BorderSide(
        width: 2,
        color: Color(0xFF141414),
      ),
    ),
    isDense: true,
  );
  TextEditingController destinationTextController = TextEditingController();
  TextEditingController amountTextController = TextEditingController();

  String selectedTokenContract = "NATIVE";
  String gasFee = "";

  bool isFetchingGasFee = false;
  bool isSubmittingTransaction = false;

  void fetchGasFee() async {
    setState(() {
      isFetchingGasFee = true;
      gasFee = "";
    });

    // Transaction Desc
    String destinationAddress = destinationTextController.text;
    EtherAmount? amount = EtherAmount.fromBigInt(
      EtherUnit.wei,
      BigInt.from(
        double.parse(
              amountTextController.text == "" ? "0" : amountTextController.text,
            ) *
            pow(10, 18),
      ),
    );

    // Fetch Gas Fee
    EtherAmount gasEstimation = selectedTokenContract == "NATIVE"
        ? await ChainRepository.fetchEstimateGasFee(
            receipentPublicAddress: destinationAddress,
            chain: HomeController.to.currentActiveChain,
          )
        : await ChainRepository.fetchEstimateTokenTransferGasFee(
            senderPublicAddress:
                HomeController.to.currentActiveWallet.publicAddress!,
            receipentPublicAddress: destinationAddress,
            contractAddress: selectedTokenContract,
            chain: HomeController.to.currentActiveChain,
            value: amount,
          );

    setState(() {
      isFetchingGasFee = false;
      gasFee = gasEstimation
          .getValueInUnit(EtherUnit.ether)
          .toStringAsFixed(10)
          .toString();
    });
  }

  void sendTransaction() async {
    setState(() {
      isSubmittingTransaction = true;
    });
    try {
      // Setup Transaction Desc
      EtherAmount amount = EtherAmount.fromBigInt(
        EtherUnit.wei,
        BigInt.from(
          double.parse(amountTextController.text) * pow(10, 18),
        ),
      );
      String destinationAddress = destinationTextController.text;

      // Send Transaction
      String transactionAddress = selectedTokenContract == "NATIVE"
          ? await ChainRepository.sendTransaction(
              HomeController.to.currentActiveWallet.privateKey!,
              destinationAddress,
              HomeController.to.currentActiveChain,
              amount,
            )
          : await ChainRepository.transferToken(
              receipentPublicAddress: destinationAddress,
              chain: HomeController.to.currentActiveChain,
              contractAddressHex: selectedTokenContract,
              amount: amount,
            );

      // Getting Done Transaction
      reset();
      Get.snackbar(
        "Transaction Success",
        transactionAddress,
        snackPosition: SnackPosition.TOP,
      );
    } on Exception catch (err) {
      Get.snackbar(
        "Transaction Failed",
        err.toString(),
        snackPosition: SnackPosition.TOP,
      );
    }
    setState(() {
      isSubmittingTransaction = false;
    });
  }

  bool isCanSubmit() {
    if (gasFee == "") {
      return false;
    }
    if (amountTextController.text == "" ||
        destinationTextController.text == "") {
      return false;
    }
    return true;
  }

  void reset() {
    destinationTextController.text = "";
    amountTextController.text = "";
    gasFee = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Transfer ${HomeController.to.currentActiveChain.symbol}",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF141414),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: destinationTextController,
                        decoration: textFieldDecoration.copyWith(
                          label: const Text("Receipent"),
                        ),
                        onChanged: (val) {
                          fetchGasFee();
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 100, child: _buildTokenSelect()),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: amountTextController,
                              keyboardType: TextInputType.number,
                              decoration: textFieldDecoration.copyWith(
                                label: const Text("Amount"),
                              ),
                              onChanged: (val) {
                                fetchGasFee();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          _buildMaxButton()
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isFetchingGasFee
                          ? const CircularProgressIndicator()
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  gasFee == ""
                                      ? ""
                                      : "Gas Fees (${HomeController.to.currentActiveChain.symbol})",
                                  style: TextStyle(
                                    color: const Color(0xFF141414)
                                        .withOpacity(0.4),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                isFetchingGasFee
                                    ? const Text("")
                                    : Text(
                                        gasFee == "" ? "" : gasFee,
                                        style: const TextStyle(
                                          color: Color(0xFF141414),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            gasFee == ""
                                ? ""
                                : "Total: (${HomeController.to.currentActiveChain.symbol})",
                            style: TextStyle(
                              color: const Color(0xFF141414).withOpacity(0.4),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          isFetchingGasFee
                              ? const Text("")
                              : Text(
                                  totalAmount(gasFee, amountTextController) ==
                                          "0.0"
                                      ? ""
                                      : totalAmount(
                                          gasFee, amountTextController),
                                  style: const TextStyle(
                                    color: Color(0xFF141414),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              _buildSubmitButton(),
              const SizedBox(height: 6.0),
            ],
          ),
        ),
      ),
    );
  }

  String totalAmount(
      String gasFee, TextEditingController amountTextController) {
    double totalAmount = double.parse(gasFee == "" ? "0" : gasFee) +
        double.parse(
            amountTextController.text == "" ? "0" : amountTextController.text);
    return totalAmount.toString();
  }

  Widget _buildMaxButton() {
    return InkWell(
      onTap: () {
        if (selectedTokenContract == "NATIVE") {
          amountTextController.text =
              HomeController.to.nativeBalance.toString();
        } else {
          amountTextController.text =
              HomeController.to.contractToBalance[selectedTokenContract]!;
        }
        fetchGasFee();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
            color: const Color(0xFF141414).withOpacity(0.1),
            borderRadius: BorderRadius.circular(13)),
        child: const Text(
          "MAX",
          style: TextStyle(
            color: Color(0xFF141414),
          ),
        ),
      ),
    );
  }

  Widget _buildTokenSelect() {
    return DropdownButtonFormField<String>(
      style: const TextStyle(
        overflow: TextOverflow.ellipsis,
        color: Color(0xFF141414),
      ),
      isDense: true,
      decoration: textFieldDecoration.copyWith(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 8,
        ),
      ),
      value: selectedTokenContract,
      items: [
        DropdownMenuItem(
          value: "NATIVE",
          child: Text(
            HomeController
                .to
                .wallets[HomeController.to.currentActiveWalletIndex]
                .chains[HomeController.to.currentActiveChainIndex]
                .symbol!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        ...HomeController.to.wallets[HomeController.to.currentActiveWalletIndex]
            .chains[HomeController.to.currentActiveChainIndex].tokens
            .map((TokenModel token) => DropdownMenuItem(
                  value: token.contract,
                  child: Text(
                    token.symbol!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ))
            .toList()
      ],
      onChanged: (val) {
        if (val != null) {
          setState(() {
            selectedTokenContract = val;
            amountTextController.text = "";
          });
          fetchGasFee();
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return isSubmittingTransaction
        ? const SizedBox(
            height: 50,
            width: 50,
            child: Center(child: CircularProgressIndicator()),
          )
        : ElevatedButton(
            onPressed: () {
              if (isCanSubmit() == false) {
                return;
              }
              sendTransaction();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(
                  255, 71, 10, 177), // Customize button background color
              foregroundColor: Colors.white, // Customize button text color
            ),
            child: const Text(
              "Submit Transaction",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          );
  }
}
