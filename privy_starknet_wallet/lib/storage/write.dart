import 'package:shared_preferences/shared_preferences.dart';

Future<String> writeValue(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);

  return 'done';
}
