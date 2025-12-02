import '../utils/privy_instance.dart';
import '../storage/read.dart';
import '../utils/make_http_request.dart';

Future<dynamic> increaseCounter() async {
  await privy.getAuthState();

  String walletId = await readValue('wallet-id');

  String urlPath = '/increase-counter/$walletId';
  Map value = await makeRequest(urlPath);

  return value;
}
