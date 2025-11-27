import 'package:privy_flutter/privy_flutter.dart';
import '../utils/privy_instance.dart';

Future<bool> checkPrivyAuth() async {
  await privy.getAuthState();
  bool isAuthenticated = privy.currentAuthState.isAuthenticated;

  print('checkPrivyAuth: $isAuthenticated');

  return isAuthenticated;
}
