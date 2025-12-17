import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';

class HelloUI extends StatelessWidget {
  HelloUI({super.key});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Hello DApp")),
      body: Center(
        child: contractLink.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello ${contractLink.deployedName}",
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter your name",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      contractLink.setName(nameController.text);
                    },
                    child: const Text("Set Name"),
                  ),
                ],
              ),
      ),
    );
  }
}
