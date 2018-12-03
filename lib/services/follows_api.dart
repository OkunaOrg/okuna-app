import 'package:Openbook/services/httpie.dart';

class FollowsApiService {
  HttpieService _httpService;

  String apiURL;

  static const FOLLOW_USER_PATH = 'api/follows/follow/';
  static const UNFOLLOW_USER_PATH = 'api/follows/unfollow/';
  static const UPDATE_FOLLOW_PATH = 'api/follows/update/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> followUserWithUsername(String username, {int listId}) {
    Map<String, dynamic> body = {'username': username};

    if (listId != null) body['list_id'] = listId;

    return _httpService.postJSON('$apiURL$FOLLOW_USER_PATH',
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unFollowUserWithUsername(String username) {
    return _httpService.postJSON('$apiURL$UNFOLLOW_USER_PATH',
        body: {'username': username}, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> updateFollowWithUsername(String username,
      {int listId}) {
    Map<String, dynamic> body = {'username': username};

    if (listId != null) body['list_id'] = listId;

    return _httpService.postJSON('$apiURL$UPDATE_FOLLOW_PATH',
        body: body, appendAuthorizationToken: true);
  }
}
