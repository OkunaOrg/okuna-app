import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class EnvironmentLoader {
  final String environmentPath;

  EnvironmentLoader({this.environmentPath});

  Future<Environment> load() {
    return rootBundle.loadStructuredData<Environment>(this.environmentPath,
        (jsonStr) async {
      final environmentLoader = Environment.fromJson(json.decode(jsonStr));
      return environmentLoader;
    });
  }
}

class Environment {
  final String apiUrl;
  final String magicHeaderName;
  final String magicHeaderValue;

  Environment(
      {this.apiUrl = '',
      this.magicHeaderName = '',
      this.magicHeaderValue = ''});

  factory Environment.fromJson(Map<String, dynamic> jsonMap) {
    return new Environment(
      apiUrl: jsonMap["API_URL"],
      magicHeaderName: jsonMap["MAGIC_HEADER_NAME"],
      magicHeaderValue: jsonMap["MAGIC_HEADER_VALUE"],
    );
  }
}
