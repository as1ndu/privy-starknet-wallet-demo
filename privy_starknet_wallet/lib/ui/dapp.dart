import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:privy_flutter/privy_flutter.dart';
import 'package:privy_starknet_wallet/contracts/decrease_counter.dart';
import 'package:privy_starknet_wallet/contracts/get_counter_value.dart';
import 'package:url_launcher/url_launcher.dart';

import '../wallet/create_wallet.dart';

import '../storage/read.dart';
import '../storage/write.dart';

import '../auth/check_privy_auth.dart';
import '../auth/logout.dart';

import '../ui/auth/email.dart';

import '../auth/get_access_token.dart';

//bool isAuthenticated = true;

import '../auth/get_current_user.dart';

import '../wallet/get_email.dart';

import '../wallet/deploy_wallet.dart';

import '../contracts/increase_counter.dart';

import '../contracts/increase_counter.dart';

class Dapp extends StatefulWidget {
  const Dapp({super.key, required this.title});

  final String title;

  @override
  State<Dapp> createState() => _DappState();
}

class _DappState extends State<Dapp> {
  bool _isAuth = false;
  String _walletId = 'null';
  String _walletAddress = 'null';
  String _userEmail = 'null';
  int _counterValue = 0;

  // await readValue('wallet-id');
  // await readValue('wallet-address');

  // Activates every time the Dapp Screen loads
  @override
  void initState() {
    super.initState();

    _isAuthCheck(); // check auth when veiwing dapp screen

    //print('initState: $_isAuth');

    getJWTToken().then((onValue) async {
      switch (onValue) {
        case Success(value: final String message):
          print(message);

        case Failure(error: final message):
          print('exception: ${message}');
          break;
        default:
      }
    });

    // Check if wallet exists
    readValue('wallet-id').then((onValue) async {
      // if wallets exist display values
      readValue('wallet-id').then((onValue) {
        // update wallet id
        setState(() {
          _walletId = onValue;
        });
      });

      readValue('wallet-address').then((onValue) {
        // update wallet address
        setState(() {
          _walletAddress = onValue;
        });
      });
    });
  }

  Future<dynamic> _isAuthCheck() async {
    checkPrivyAuth().then((onValue) {
      setState(() {
        // update auth status
        _isAuth = onValue;
      });

      if (onValue) {
        // if user authenticated sucessfully

        getEmail().then((onValue) {
          // update user emails
          setState(() {
            _userEmail = onValue;
          });
        });

        getCurrentUser().then((onValue) {
          // save userId
          writeValue('userId', onValue['id']);

          dynamic linkedAccountList = onValue['linked_accounts'];
          dynamic filteredItems = linkedAccountList
              .where(
                (item) =>
                    item['type'] == 'wallet' &&
                    item['chain_type'] == 'starknet',
              )
              .toList();

          if (filteredItems.isEmpty) {
            // create new starknet wallet

            readValue('userId').then((onValue) {
              createWallet().then((onValue) {
                // store wallet aadress
                writeValue('wallet-address', onValue['address']);

                // store wallet id
                writeValue('wallet-id', onValue['id']);

                setState(() {
                  _walletAddress = "Deploying Argent wallet, wait a bit ...";
                });

                deployNewWallet().then((onValue) async {
                  String wallet_address = await readValue('wallet-address');

                  setState(() {
                    _walletAddress = wallet_address;
                  });
                });
              });
            });

            // store wallet address

            // store wallet id

            // deploy wallet
          } else {
            dynamic wallet = filteredItems[0];
            String wallet_address = wallet['address'];
            String wallet_id = wallet['id'];

            // store wallet address
            writeValue('wallet-address', wallet_address);

            setState(() {
              _walletAddress = wallet_address;
            });

            // store wallet id
            writeValue('wallet-id', wallet_id);
          }
        });
      }
    });

    //print('_isAuthCheck: $_isAuth');
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
                      Column(
                        mainAxisAlignment: .end,
                        children: [Text(''), Text('')],
                      ),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Wallet Address',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              child: Text(_walletAddress),
                              onTap: () async {
                                print('tap');
                                final Uri url = Uri.parse(
                                  'https://sepolia.voyager.online/contract/$_walletAddress',
                                );
                                await launchUrl(url);
                              },
                            ),
                            Divider(),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              'Email ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_userEmail),
                          ],
                        ),
                      ),
                      Text(
                        '$_counterValue',
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
                        onPressed: () async {
                          // Increase counter
                          await increaseCounter();
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
                        onPressed: () async {
                          // Decrease counter
                          await decreaseCounter();
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
                            Text('Get Current Value'),
                          ],
                        ),
                        onPressed: () async {
                          int latestCount = await getCurrentCount();
                          setState(() {
                            _counterValue = latestCount;
                          });
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
