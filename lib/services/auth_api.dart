import 'dart:io';

import 'package:Openbook/services/httpie.dart';
import 'package:meta/meta.dart';

class AuthApiService {
  HttpieService _httpService;

  String apiURL;

  static const CHECK_USERNAME_PATH = 'api/auth/username-check/';
  static const CHECK_EMAIL_PATH = 'api/auth/email-check/';
  static const CREATE_ACCOUNT_PATH = 'api/auth/register/';
  static const GET_AUTHENTICATED_USER_PATH = 'api/auth/user/';
  static const UPDATE_AUTHENTICATED_USER_PATH = 'api/auth/user/';
  static const GET_USERS_PATH = 'api/auth/users/';
  static const LOGIN_PATH = 'api/auth/login/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> checkUsernameIsAvailable({@required String username}) {
    return _httpService
        .postJSON('$apiURL$CHECK_USERNAME_PATH', body: {'username': username});
  }

  Future<HttpieResponse> checkEmailIsAvailable({@required String email}) {
    return _httpService
        .postJSON('$apiURL$CHECK_EMAIL_PATH', body: {'email': email});
  }

  Future<HttpieStreamedResponse> updateUser({
    dynamic avatar,
    dynamic cover,
    String name,
    String username,
    String url,
    String password,
    String birthDate,
    bool followersCountVisible,
    String bio,
    String location,
  }) {
    Map<String, dynamic> body = {};

    if (avatar is File) {
      body['avatar'] = avatar;
    } else if (avatar is String) {
      // This is what deletes the avatar. Ugly af.
      body['avatar'] = '';
    }

    if (cover is File) {
      body['cover'] = cover;
    } else if (cover is String) {
      // This is what deletes the cover. Ugly af.
      body['cover'] = '';
    }

    if (name != null) body['name'] = name;

    if (username != null) body['username'] = username;

    if (url != null) body['url'] = url;

    if (password != null) body['password'] = password;

    if (birthDate != null) body['birthDate'] = birthDate;

    if (bio != null) body['bio'] = bio;

    if (followersCountVisible != null)
      body['followersCountVisible'] = followersCountVisible;

    if (location != null) body['location'] = location;

    return _httpService.patchMultiform('$apiURL$UPDATE_AUTHENTICATED_USER_PATH',
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> createUser(
      {@required String email,
      @required String username,
      @required String name,
      @required String birthDate,
      @required String password,
      File avatar}) {
    Map<String, dynamic> body = {
      'email': email,
      'username': username,
      'name': name,
      'birth_date': birthDate,
      'password': password
    };

    if (avatar != null) {
      body['avatar'] = avatar;
    }

    return _httpService.postMultiform('$apiURL$CREATE_ACCOUNT_PATH',
        body: body);
  }

  Future<HttpieResponse> getUserWithAuthToken(String authToken) {
    Map<String, String> headers = {'Authorization': 'Token $authToken'};

    return _httpService.get('$apiURL$GET_AUTHENTICATED_USER_PATH',
        headers: headers);
  }

  Future<HttpieResponse> getUserWithUsername(String username,
      {bool authenticatedRequest = true}) {
    return _httpService.get('$apiURL$GET_USERS_PATH$username/',
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> loginWithCredentials(
      {@required String username, @required String password}) {
    return this._httpService.postJSON('$apiURL$LOGIN_PATH',
        body: {'username': username, 'password': password});
  }
}
