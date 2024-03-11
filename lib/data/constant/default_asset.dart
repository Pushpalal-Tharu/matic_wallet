import 'package:matic_wallet/model/chain_model.dart';

final List<ChainModel> defaultChains = [
  ChainModel(
    name: "Polygon",
    rpcUrl: "https://polygon-bor.publicnode.com",
    symbol: "MATIC",
    tokens: [],
    chainId: "137",
  ),
  ChainModel(
    name: "Mumbai Testnet",
    rpcUrl: "https://polygon-mumbai.blockpi.network/v1/rpc/public",
    symbol: "MATIC",
    tokens: [],
    chainId: "80001",
  ),
  ChainModel(
    name: "Sepolia Test Network",
    rpcUrl: "https://ethereum-sepolia.blockpi.network/v1/rpc/public",
    symbol: "ETH",
    tokens: [],
    chainId: "11155111",
  ),
  ChainModel(
    name: "Ethereum Mainnet",
    rpcUrl: "https://eth.llamarpc.com",
    symbol: "ETH",
    tokens: [],
    chainId: "1",
  ),
  ChainModel(
    name: "Neon EVM Mainnet",
    rpcUrl: "https://neon-proxy-mainnet.solana.p2p.org",
    symbol: "NEON",
    tokens: [],
    chainId: "245022934",
  ),
  ChainModel(
    name: "Neon EVM Devnet",
    rpcUrl: "https://devnet.neonevm.org",
    symbol: "NEON",
    tokens: [],
    chainId: "245022926",
  ),
];
