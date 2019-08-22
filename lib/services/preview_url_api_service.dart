import 'package:Okuna/services/httpie.dart';
import 'package:flutter/cupertino.dart';

class PreviewUrlApiService {
  HttpieService _httpService;
  String apiURL;

  static const PREVIEW_URL_PATH = 'api/link-preview/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getPreviewDataForUrl({@required String url}) {
    Map<String, dynamic> queryParams = {};
    queryParams['url'] = url;
    return _httpService.get(_makeApiUrl(PREVIEW_URL_PATH),
        queryParameters: queryParams,
        appendAuthorizationToken: true);
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}