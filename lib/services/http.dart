import 'dart:convert';

import 'package:http/http.dart';

class HttpService {
  Future<Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return post(url, headers: headers, body: body, encoding: encoding);
  }
}
