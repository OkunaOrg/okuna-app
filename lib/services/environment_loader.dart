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
  final String API_URL;
  final String MAGIC_HEADER_NAME;
  final String MAGIC_HEADER_VALUE;

  Environment(
      {this.API_URL = '',
      this.MAGIC_HEADER_NAME = '',
      this.MAGIC_HEADER_VALUE = ''});

  factory Environment.fromJson(Map<String, dynamic> jsonMap) {
    return new Environment(
      API_URL: jsonMap["API_URL"],
      MAGIC_HEADER_NAME: jsonMap["MAGIC_HEADER_NAME"],
      MAGIC_HEADER_VALUE: jsonMap["MAGIC_HEADER_VALUE"],
    );
  }
}
