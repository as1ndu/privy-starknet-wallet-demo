import '../utils/privy_instance.dart';
import '../storage/read.dart';
import '../utils/make_http_request.dart';

Future<dynamic> getCurrentUser() async {
  await privy.getAuthState();

  String useEmail = await readValue('email');
  String urlPath = '/get-user-by-email/$useEmail';
  Map userDetails = await makeRequest(urlPath);

  return userDetails;
}
