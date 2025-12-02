import '../utils/privy_instance.dart';
import '../storage/read.dart';
import '../utils/make_http_request.dart';

Future<dynamic> deployNewWallet() async {
  await privy.getAuthState();

  String walletId = await readValue('wallet-id');

  String urlPath = '/deploy-argentx-account/$walletId';
  Map userDetails = await makeRequest(urlPath);

  return userDetails;
}
