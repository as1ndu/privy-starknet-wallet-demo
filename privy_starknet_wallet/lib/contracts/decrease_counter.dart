import '../utils/privy_instance.dart';
import '../storage/read.dart';
import '../utils/make_http_request.dart';

Future<dynamic> decreaseCounter() async {
  await privy.getAuthState();

  String walletId = await readValue('wallet-id');

  String urlPath = '/decrease-counter/$walletId';
  Map value = await makeRequest(urlPath);

  return value;
}
