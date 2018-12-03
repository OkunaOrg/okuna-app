import 'package:Openbook/services/httpie.dart';

class ConnectionsApiService {
  HttpieService _httpService;

  String apiURL;

  static const CONNECT_WITH_USER_PATH = 'api/connections/connect/';
  static const DISCONNECT_FROM_USER_PATH = 'api/connections/disconnect/';
  static const UPDATE_CONNECTION_PATH = 'api/connections/update/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> connectWithUserWithUsername(String username,
      {List<int> circlesIds}) {
    Map<String, dynamic> body = {'username': username};

    if (circlesIds != null) body['circles_ids'] = circlesIds;

    return _httpService.postJSON('$apiURL$CONNECT_WITH_USER_PATH',
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> disconnectFromUserWithUsername(String username) {
    return _httpService.postJSON('$apiURL$DISCONNECT_FROM_USER_PATH',
        body: {'username': username}, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> updateConnectionWithUsername(String username,
      {List<int> circlesIds}) {
    Map<String, dynamic> body = {'username': username};

    if (circlesIds != null) body['circles_ids'] = circlesIds;

    return _httpService.postJSON('$apiURL$UPDATE_CONNECTION_PATH',
        body: body, appendAuthorizationToken: true);
  }
}
