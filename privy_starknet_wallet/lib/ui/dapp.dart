import 'package:flutter/material.dart';

import '../auth/check_privy_auth.dart';
import '../auth/logout.dart';

import '../ui/auth/email.dart';

//bool isAuthenticated = true;

class Dapp extends StatefulWidget {
  const Dapp({super.key, required this.title});

  final String title;

  @override
  State<Dapp> createState() => _DappState();
}

class _DappState extends State<Dapp> {
  bool _isAuth = false;

  // Activates every time the Dapp Screen loads
  @override
  void initState() {
    super.initState();

    _isAuthCheck(); // check auth when veiwing dapp screen

    print('initState: $_isAuth');
  }

  void _isAuthCheck() {
    checkPrivyAuth().then((onValue) {
      setState(() {
        // update auth status
        _isAuth = onValue;
      });
    });

    print('_isAuthCheck: $_isAuth');
  }

  @override
  Widget build(BuildContext context) {
    // if its not authenticated, request for email
    return (_isAuth == false)
        ? EnterEmail()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
              automaticallyImplyLeading: false,
              actions: [
                ElevatedButton(
                  child: Row(children: [Icon(Icons.logout), Text('Logout')]),
                  onPressed: () async {
                    await logoutUser();

                    Navigator.push(
                      (context),
                      MaterialPageRoute(builder: (context) => EnterEmail()),
                    );
                  },
                ),
              ],
            ),

            body: Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Column(
                    children: [
                      Text(
                        '0',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text('counter value'),
                    ],
                  ),

                  SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      ElevatedButton(
                        child: Row(
                          children: [
                            Icon(Icons.arrow_upward),
                            Text('Increase Value'),
                          ],
                        ),
                        onPressed: () {
                          //
                        },
                      ),

                      SizedBox(width: 40),

                      ElevatedButton(
                        child: Row(
                          children: [
                            Icon(Icons.arrow_downward),
                            Text('Decrease Value'),
                          ],
                        ),
                        onPressed: () {
                          //
                        },
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      ElevatedButton(
                        child: Row(
                          children: [
                            Icon(Icons.dataset_linked_sharp),
                            Text('View Value'),
                          ],
                        ),
                        onPressed: () {
                          //
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
