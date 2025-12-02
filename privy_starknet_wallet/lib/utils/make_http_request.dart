import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

Future<Map> makeRequest(String urlPath) async {
  var url = Uri.http(baseURL, urlPath);
  var response = await http.get(url);

  Map<String, dynamic> decodedResponse = jsonDecode(response.body);

  return decodedResponse;
}
