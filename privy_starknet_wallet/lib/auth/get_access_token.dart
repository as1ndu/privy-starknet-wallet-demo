import 'package:privy_flutter/privy_flutter.dart';

import '../utils/privy_instance.dart';

Future<dynamic> getJWTToken() async {
  await privy.getAuthState();
  //await privy.currentAuthState.user?.refresh();
  dynamic token = await privy.currentAuthState.user?.getAccessToken();

  return token;
}
