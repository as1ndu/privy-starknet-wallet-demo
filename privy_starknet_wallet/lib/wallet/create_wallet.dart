import '../utils/privy_instance.dart';
import '../storage/read.dart';
import '../utils/make_http_request.dart';

Future<dynamic> createWallet() async {
  await privy.getAuthState();

  String userId = await readValue('userId');

  String urlPath = '/create-wallet/$userId';
  Map userDetails = await makeRequest(urlPath);

  return userDetails;
}
