import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/services.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://10.0.2.2:7545";
  final String _wsUrl = "ws://10.0.2.2:7545/";
  final String _privateKey =
      "0x29ec0e1b29ea57edd9ce410b521af58dc3d2298d07c094d72e50d0f0f9189ae2";

  late Web3Client _client;
  bool isLoading = true;

  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _yourName;
  late ContractFunction _setName;

  String deployedName = "";

  ContractLinking() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    _client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () => IOWebSocketChannel.connect(_wsUrl).cast<String>(),
    );
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    final abiString = await rootBundle.loadString(
      "src/artifacts/HelloWorld.json",
    );
    final jsonAbi = jsonDecode(abiString);

    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(
      jsonAbi["networks"]["5777"]["address"],
    );
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "HelloWorld"),
      _contractAddress,
    );

    _yourName = _contract.function("yourName");
    _setName = _contract.function("setName");

    await getName();
  }

  Future<void> getName() async {
    final result = await _client.call(
      contract: _contract,
      function: _yourName,
      params: [],
    );

    deployedName = result[0];
    isLoading = false;
    notifyListeners();
  }

  Future<void> setName(String name) async {
    isLoading = true;
    notifyListeners();

    final gasPrice = await _client.getGasPrice();

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _setName,
        parameters: [name],
        maxGas: 100000,
        gasPrice: gasPrice,
      ),
      chainId: 5777,
    );

    await getName();
  }
}
