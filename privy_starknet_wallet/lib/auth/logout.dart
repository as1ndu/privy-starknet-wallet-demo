import '../utils/privy_instance.dart';

Future<void> logoutUser() async {
  await privy.logout();
  print('..logged out');
}
