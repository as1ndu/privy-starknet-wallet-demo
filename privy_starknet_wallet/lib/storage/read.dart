import 'package:shared_preferences/shared_preferences.dart';

Future<String> readValue(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String value = prefs.getString(key).toString();
  return value;
}
