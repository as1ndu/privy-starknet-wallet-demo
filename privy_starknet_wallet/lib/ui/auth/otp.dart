import 'package:flutter/material.dart';

import '../../utils/privy_instance.dart';

import '../../storage/write.dart';

import '../dapp.dart';

class EnterOTP extends StatefulWidget {
  final String userEmail;

  const EnterOTP({super.key, required this.userEmail});

  @override
  State<EnterOTP> createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  final otpFieldController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    otpFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privy Starknet Flutter Wallet Demo.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text('Enter OTP'),
            SizedBox(
              width: 240,
              child: TextFormField(
                controller: otpFieldController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter OTP',
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Verify'),
              onPressed: () async {
                // Verify OTP
                final response = await privy.email.loginWithCode(
                  code: otpFieldController.text,
                  email: widget.userEmail,
                );

                response.fold(
                  onSuccess: (_) async {
                    await writeValue('email', widget.userEmail);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Dapp(title: 'Privy & Starknet Demo'),
                      ),
                    );
                  },
                  onFailure: (error) {
                    print(error.message);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
