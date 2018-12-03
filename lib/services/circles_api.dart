import 'dart:io';

import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:meta/meta.dart';

class CirclesApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const GET_CIRCLES_PATH = 'api/circles/';
  static const CREATE_CIRCLE_PATH = 'api/circles/';
  static const UPDATE_CIRCLE_PATH = 'api/circles/{circleId}';
  static const DELETE_CIRCLE_PATH = 'api/circles/{circleId}';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getCircles() {
    String url = _makeApiUrl(GET_CIRCLES_PATH);
    return _httpService.get(url, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> createCircle({@required String name, String color}) {
    String url = _makeApiUrl(CREATE_CIRCLE_PATH);
    Map<String, dynamic> body = {'name': name};

    if (color != null) body['color'] = color;

    return _httpService.putJSON(url,
        appendAuthorizationToken: true, body: body);
  }

  Future<HttpieResponse> updateCircleWithId(int circleId,
      {String name, String color}) {
    Map<String, dynamic> body = {};

    if (color != null) body['color'] = color;

    if (name != null) body['name'] = name;

    String url = _makeUpdateCirclePath(circleId);
    return _httpService.patchJSON(url,
        appendAuthorizationToken: true, body: body);
  }

  Future<HttpieResponse> deleteCircleWithId(int circleId) {
    String url = _makeDeleteCirclePath(circleId);
    return _httpService.delete(url, appendAuthorizationToken: true);
  }

  String _makeUpdateCirclePath(int circleId) {
    return _stringTemplateService
        .parse(UPDATE_CIRCLE_PATH, {'circleId': circleId});
  }

  String _makeDeleteCirclePath(int circleId) {
    return _stringTemplateService
        .parse(DELETE_CIRCLE_PATH, {'circleId': circleId});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
