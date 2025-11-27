import '../utils/privy_instance.dart';

dynamic verifyOTP(String email, String code) async {
  final response = await privy.email.loginWithCode(code: code, email: email);
  return response;
}
