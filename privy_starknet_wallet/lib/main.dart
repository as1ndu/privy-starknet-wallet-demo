import 'package:flutter/material.dart';

// import Screens
import 'ui/dapp.dart';

void main() {
  runApp(const PrivyStarknetWalletDemo());
}

// Root of Application
class PrivyStarknetWalletDemo extends StatelessWidget {
  const PrivyStarknetWalletDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Privy Starknet Wallet Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),

      // Renders Dapp Home page
      home: const Dapp(title: 'Privy & Starknet Demo'),
    );
  }
}
