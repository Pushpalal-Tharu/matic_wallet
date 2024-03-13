import 'package:matic_wallet/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matic_wallet/data/repository/account_repository.dart';
import 'package:matic_wallet/pages/home/components/send_token.dart';
import 'package:matic_wallet/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (HomeController controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: controller.isInitializing
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    AccountRepository.removeWallet();
                                    Get.offAll(const LoginPage());
                                  },
                                  child: const Icon(Icons.logout),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            _buildIdentityCard(controller),
                            const SizedBox(
                              height: 14,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(const SendToken());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 71, 10, 177),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Transfer',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildIdentityCard(HomeController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (controller.wallets[controller.currentActiveWalletIndex]
                          .chains.length >
                      1) {
                    Get.bottomSheet(buildChainBottomSheet(controller));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${controller.currentActiveChain.name} Chain",
                        style: const TextStyle(color: Color(0xFF141414)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: controller
                                    .wallets[
                                        controller.currentActiveWalletIndex]
                                    .chains
                                    .length >
                                1
                            ? true
                            : false,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF141414),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.fetchBalanceFromChain();
                },
                splashColor: Colors.black,
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          SelectableText(
            "${controller.currentActiveWallet.publicAddress}",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withOpacity(0.7),
            ),
            enableInteractiveSelection: true,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "${controller.currentActiveChain.symbol} ${controller.nativeBalance}",
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildChainBottomSheet(HomeController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller
              .wallets[controller.currentActiveWalletIndex].chains
              .map(
                (e) => InkWell(
                  onTap: () {
                    controller.handleSelectNetwork(e);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color:
                            e.chainId == controller.currentActiveChain.chainId
                                ? const Color(0xFF141414).withOpacity(0.1)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 25),
                    child: Text(
                      e.name!,
                      style: const TextStyle(
                        color: Color(0xFF141414),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
