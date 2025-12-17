import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';
import 'hello_ui.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ContractLinking(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello DApp',
      home: HelloUI(),
    );
  }
}
