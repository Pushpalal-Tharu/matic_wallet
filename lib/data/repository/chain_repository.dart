import 'package:matic_wallet/controller/home_controller.dart';
import 'package:matic_wallet/model/chain_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:matic_wallet/model/token_model.dart';
import 'package:web3dart/web3dart.dart';

class ChainRepository {
  static Future<double> fetchBalanceFromChain(
      String address, ChainModel chain) async {
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    var privateKey = EthPrivateKey.fromHex(address);
    EtherAmount balance = await ethClient.getBalance(privateKey.address);
    return balance.getValueInUnit(EtherUnit.ether);
  }

  static Future<String> fetchBalanceOfToken(
    String publicAddress,
    String contractAddressHex,
    ChainModel chain,
  ) async {
    // Setup Client
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Setup Credential
    final EthereumAddress contractAddress =
        EthereumAddress.fromHex(contractAddressHex);
    final EthereumAddress address = EthereumAddress.fromHex(publicAddress);

    // Setup Contract
    String abiCode =
        await rootBundle.loadString('assets/abi/erc20tokenabi.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'Erc20Token'),
      contractAddress,
    );
    final balanceFunction = contract.function('balanceOf');

    final balance = await ethClient
        .call(contract: contract, function: balanceFunction, params: [address]);

    return balance[0].toString();
  }

  static Future<TokenModel> fetchTokenInfo(
    String publicAddress,
    String contractAddressHex,
    ChainModel chain,
  ) async {
    // Setup Client
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Setup Credential
    final EthereumAddress contractAddress =
        EthereumAddress.fromHex(contractAddressHex);
    final EthereumAddress address = EthereumAddress.fromHex(publicAddress);

    // Setup Contract
    String abiCode =
        await rootBundle.loadString('assets/abi/erc20tokenabi.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, 'Erc20Token'),
      contractAddress,
    );
    final nameFunction = contract.function('name');
    final symbolFunction = contract.function('symbol');
    final decimalsFunction = contract.function('decimals');

    final name = await ethClient
        .call(contract: contract, function: nameFunction, params: []);
    final decimal = await ethClient
        .call(contract: contract, function: decimalsFunction, params: []);
    final symbol = await ethClient
        .call(contract: contract, function: symbolFunction, params: []);
    TokenModel token = TokenModel(
        name: name[0].toString(),
        contract: contractAddressHex,
        symbol: symbol[0].toString(),
        decimal: decimal[0].toString());
    return token;
  }

  static Future<String> transferToken({
    required String receipentPublicAddress,
    required ChainModel chain,
    required String contractAddressHex,
    required EtherAmount amount,
  }) async {
    // Setup Client
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Setup Credential
    final EthereumAddress contractAddress =
        EthereumAddress.fromHex(contractAddressHex);
    final EthereumAddress recipentAddress =
        EthereumAddress.fromHex(receipentPublicAddress);
    final EthereumAddress senderAddress = EthereumAddress.fromHex(
        HomeController.to.currentActiveWallet.publicAddress!);
    EthPrivateKey privateKey = EthPrivateKey.fromHex(
      '0x${HomeController.to.currentActiveWallet.privateKey}',
    );

    // Contract Data
    final transferFunction = ContractFunction(
      'transfer',
      [
        FunctionParameter("_to", parseAbiType("address")),
        FunctionParameter("_value", parseAbiType("uint256")),
      ],
    );
    final data = transferFunction.encodeCall([
      recipentAddress,
      amount.getInWei,
    ]);

    final transaction = Transaction(
      from: senderAddress,
      to: contractAddress,
      value: EtherAmount.zero(), // For token transfers, the value is zero
      data: data,
    );

    String result = await ethClient.sendTransaction(
      privateKey,
      transaction,
      chainId: int.parse(HomeController.to.currentActiveChain.chainId!),
    );

    return result;
  }

  static Future<String> sendTransaction(
      String privateKey,
      String receipentPublicAddress,
      ChainModel chain,
      EtherAmount value) async {
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);
    if (kDebugMode) {
      print(privateKey);
    }
    if (kDebugMode) {
      print(value.getValueInUnit(EtherUnit.wei));
    }
    EtherAmount gasPrice = await ethClient.getGasPrice();
    String transaction = await ethClient.sendTransaction(
        EthPrivateKey.fromHex("0x$privateKey"),
        Transaction(
          to: EthereumAddress.fromHex(receipentPublicAddress),
          value: value,
          gasPrice: gasPrice,
        ),
        chainId: int.parse(chain.chainId!));
    if (kDebugMode) {
      print(transaction);
    }
    return transaction;
  }

  static Future<EtherAmount> fetchEstimateTokenTransferGasFee({
    required String receipentPublicAddress,
    required String senderPublicAddress,
    required String contractAddress,
    required ChainModel chain,
    required EtherAmount value,
  }) async {
    // Setup Client
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Contract Data
    final transferFunction = ContractFunction(
      'transfer',
      [
        FunctionParameter("_to", parseAbiType("address")),
        FunctionParameter("_value", parseAbiType("uint256")),
      ],
    );
    final data = transferFunction.encodeCall([
      EthereumAddress.fromHex(receipentPublicAddress),
      value.getInWei,
    ]);

    // Gas Amount
    BigInt estimatedGasAmount = await ethClient.estimateGas(
      sender: EthereumAddress.fromHex(senderPublicAddress),
      to: EthereumAddress.fromHex(contractAddress),
      data: data,
    );

    // Gas Price
    EtherAmount gasPrice = await ethClient.getGasPrice();

    // Gas Fee
    EtherAmount estimatedGasFee = EtherAmount.inWei(
      BigInt.from(gasPrice.getValueInUnit(EtherUnit.wei)) * estimatedGasAmount,
    );

    return estimatedGasFee;
  }

  static Future<EtherAmount> fetchEstimateGasFee({
    required String receipentPublicAddress,
    required chain,
  }) async {
    var httpClient = Client();
    var ethClient = Web3Client(chain.rpcUrl!, httpClient);

    // Gas Amount
    BigInt estimatedGasAmount = await ethClient.estimateGas(
      sender:
          EthereumAddress.fromHex("0xdf6D20811774aE01AaA4C13c32EebdD4290cA7fd"),
      to: EthereumAddress.fromHex(receipentPublicAddress),
    );

    // Gas Price
    EtherAmount gasPrice = await ethClient.getGasPrice();

    // Gas Fee
    EtherAmount estimatedGasFee = EtherAmount.inWei(
      BigInt.from(gasPrice.getValueInUnit(EtherUnit.wei)) * estimatedGasAmount,
    );

    return estimatedGasFee;
  }
}
