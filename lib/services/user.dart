import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/posts-list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/services/auth-api.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/posts-api.dart';
import 'package:Openbook/services/secure-storage.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  SecureStorageService _secureStorageService;

  static const STORAGE_AUTH_TOKEN_KEY = 'authToken';

  AuthApiService _authApiService;
  HttpieService _httpieService;
  PostsApiService _postsApiService;

  // If this is null, means user logged out.
  Stream<User> get loggedInUserChange => _loggedInUserChangeSubject.stream;

  User _loggedInUser;

  String _authToken;

  final _loggedInUserChangeSubject = ReplaySubject<User>(maxSize: 1);

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void setPostsApiService(PostsApiService postsApiService) {
    _postsApiService = postsApiService;
  }

  void setHttpieService(HttpieService httpieService) {
    _httpieService = httpieService;
  }

  void setSecureStorageService(SecureStorageService secureStorageService) {
    _secureStorageService = secureStorageService;
  }

  Future<void> logout() async {
    await _removeStoredAuthToken();
    _httpieService.removeAuthorizationToken();
    _removeLoggedInUser();
  }

  Future<void> loginWithCredentials(
      {@required String username, @required String password}) async {
    HttpieResponse response = await _authApiService.loginWithCredentials(
        username: username, password: password);

    if (response.isOk()) {
      var parsedResponse = response.parseJsonBody();
      var authToken = parsedResponse['token'];
      await loginWithAuthToken(authToken);
    } else if (response.isUnauthorized()) {
      throw CredentialsMismatchError('The provided credentials do not match.');
    } else {
      throw HttpieRequestError(response);
    }
  }

  Future<void> loginWithAuthToken(String authToken) async {
    await _setAuthToken(authToken);
    await refreshUser();
  }

  User getLoggedInUser() {
    return _loggedInUser;
  }

  Future<void> refreshUser() async {
    if (_authToken == null) throw AuthTokenMissingError();

    HttpieResponse response =
        await _authApiService.getUserWithAuthToken(_authToken);
    _checkResponseIsOk(response);
    var user = User.fromJson(json.decode(response.body));
    _setLoggedInUser(user);
  }

  Future<bool> loginWithStoredAuthToken() async {
    var token = await _getStoredAuthToken();
    if (token == null) throw AuthTokenMissingError();

    await loginWithAuthToken(token);
  }

  Future<bool> hasAuthToken() async {
    String authToken = await _getStoredAuthToken();
    return authToken != null;
  }

  bool isLoggedIn() {
    return _loggedInUser != null;
  }

  Future<PostsList> getAllPosts() async {
    HttpieResponse response = await _postsApiService.getAllPosts();
    _checkResponseIsOk(response);
    return PostsList.fromJson(json.decode(response.body));
  }

  Future<Post> createPost(
      {@required String text, List<int> circleIds, File image}) async {
    HttpieStreamedResponse response = await _postsApiService.createPost(
        text: text, circleIds: circleIds, image: image);

    _checkResponseIsCreated(response);

    // Post counts have changed
    refreshUser();

    String responseBody = await response.readAsString();
    return Post.fromJson(json.decode(responseBody));
  }

  void _checkResponseIsCreated(HttpieBaseResponse response) {
    if (response.isCreated()) return;
    throw HttpieRequestError(response);
  }

  void _checkResponseIsOk(HttpieBaseResponse response) {
    if (response.isOk()) return;
    throw HttpieRequestError(response);
  }

  void _setLoggedInUser(User user) {
    _loggedInUser = user;
    _loggedInUserChangeSubject.add(user);
  }

  void _removeLoggedInUser() {
    _loggedInUser = null;
    _loggedInUserChangeSubject.add(null);
  }

  Future<void> _setAuthToken(String authToken) async {
    _authToken = authToken;
    _httpieService.setAuthorizationToken(authToken);
    await _storeAuthToken(authToken);
  }

  Future<void> _storeAuthToken(String authToken) {
    return _secureStorageService.set(
        key: STORAGE_AUTH_TOKEN_KEY, value: authToken);
  }

  Future<String> _getStoredAuthToken() async {
    String authToken =
        await _secureStorageService.get(key: STORAGE_AUTH_TOKEN_KEY);
    if (authToken != null) _authToken = authToken;
    return authToken;
  }

  Future<void> _removeStoredAuthToken() async {
    _secureStorageService.remove(key: STORAGE_AUTH_TOKEN_KEY);
  }
}

class CredentialsMismatchError implements Exception {
  final String msg;

  const CredentialsMismatchError(this.msg);

  String toString() => 'CredentialsMismatchError: $msg';
}

class AuthTokenMissingError implements Exception {
  const AuthTokenMissingError();

  String toString() => 'AuthTokenMissingError: No auth token was found.';
}

class NotLoggedInUserError implements Exception {
  const NotLoggedInUserError();

  String toString() => 'NotLoggedInUserError: No user is logged in.';
}

class AuthTokenInvalidError implements Exception {
  const AuthTokenInvalidError();

  String toString() => 'InvalidAuthTokenError: The provided token is invalid.';
}
