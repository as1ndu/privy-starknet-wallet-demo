import 'package:flutter/material.dart';

// ui screen for OTP
import './otp.dart';

import '../../utils/privy_instance.dart';

class EnterEmail extends StatefulWidget {
  const EnterEmail({super.key});

  @override
  State<EnterEmail> createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  final emailTextFieldController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailTextFieldController.dispose();
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
            Text('Enter Email'),
            SizedBox(
              width: 240,
              child: TextFormField(
                controller: emailTextFieldController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Email',
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Request OTP'),
              onPressed: () async {
                // get email address from TextField
                final response = await privy.email.sendCode(
                  emailTextFieldController.text,
                );

                response.fold(
                  onSuccess: (_) {
                    // Request for OTP
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EnterOTP(userEmail: emailTextFieldController.text),
                      ),
                    );
                  },

                  // Error Message
                  onFailure: (error) {
                    print(error.message);
                  },
                );

                // move to OTP Screen
                //print(emailTextFieldController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
