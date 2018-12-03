import 'dart:io';

import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:meta/meta.dart';

class ListsApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const GET_LISTS_PATH = 'api/lists/';
  static const CREATE_LIST_PATH = 'api/lists/';
  static const UPDATE_LIST_PATH = 'api/lists/{listId}';
  static const DELETE_LIST_PATH = 'api/lists/{listId}';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getLists() {
    String url = _makeApiUrl(GET_LISTS_PATH);
    return _httpService.get(url, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> createList({@required String name, String emojiId}) {
    String url = _makeApiUrl(CREATE_LIST_PATH);
    Map<String, dynamic> body = {'name': name};

    if (emojiId != null) body['emoji_id'] = emojiId;

    return _httpService.putJSON(url,
        appendAuthorizationToken: true, body: body);
  }

  Future<HttpieResponse> updateListWithId(int listId,
      {String name, String emojiId}) {
    Map<String, dynamic> body = {};

    if (emojiId != null) body['emoji_id'] = emojiId;

    if (name != null) body['name'] = name;

    String url = _makeUpdateListPath(listId);
    return _httpService.patchJSON(url,
        appendAuthorizationToken: true, body: body);
  }

  Future<HttpieResponse> deleteListWithId(int listId) {
    String url = _makeDeleteListPath(listId);
    return _httpService.delete(url, appendAuthorizationToken: true);
  }

  String _makeUpdateListPath(int listId) {
    return _stringTemplateService
        .parse(UPDATE_LIST_PATH, {'listId': listId});
  }

  String _makeDeleteListPath(int listId) {
    return _stringTemplateService
        .parse(DELETE_LIST_PATH, {'listId': listId});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
