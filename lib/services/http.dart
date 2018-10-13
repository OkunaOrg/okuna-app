import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  Future<http.Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return http.post(url, headers: headers, body: body, encoding: encoding);
  }

  Future<http.Response> postJSON(url,
      {Map<String, String> headers = const {}, body, encoding}) {
    String jsonBody = json.encode(body);

    Map<String, String> jsonHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, String> mergedHeaders = {};

    mergedHeaders.addAll(headers);
    mergedHeaders.addAll(jsonHeaders);

    return post(url,
        headers: mergedHeaders, body: jsonBody, encoding: encoding);
  }
}
