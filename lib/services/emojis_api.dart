import 'dart:io';

import 'package:Openbook/services/httpie.dart';
import 'package:meta/meta.dart';

class EmojisApiService {
  HttpieService _httpService;

  String apiURL;

  static const GET_EMOJI_GROUPS_PATH = 'api/emojis/groups/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getEmojiGroups() {
    String url = _makeApiUrl(GET_EMOJI_GROUPS_PATH);
    return _httpService.get(url, appendAuthorizationToken: true);
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
