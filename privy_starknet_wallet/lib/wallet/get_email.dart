import '../storage/read.dart';

Future<dynamic> getEmail() async {
  String email = await readValue('email');

  return email;
}
