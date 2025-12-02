import '../utils/privy_instance.dart';

dynamic requestOTP(String email) async {
  final response = await privy.email.sendCode(email);

  // create new wallet and store wallet id

  return response;
}
