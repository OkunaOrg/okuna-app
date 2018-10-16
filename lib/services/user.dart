import 'dart:_http';
import 'dart:async';
import 'dart:convert';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/services/auth-api.dart';
import 'package:Openbook/services/http.dart';
import 'package:Openbook/services/secure-storage.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  SecureStorageService _secureStorageService;

  static const STORAGE_AUTH_TOKEN_KEY = 'authToken';

  AuthApiService _authApiService;

  Stream<User> get loggedInUserChange => _loggedInUserChangeSubject.stream;

  User _loggedInUser;

  String _authToken;

  final _loggedInUserChangeSubject = BehaviorSubject<User>();

  Future<void> loginWithCredentials(
      {@required String username, @required String password}) async {
    Response response = await _authApiService.loginWithCredentials(
        username: username, password: password);

    if (response.statusCode == HttpStatus.ok) {
      var parsedResponse = json.decode(response.body);
      var authToken = parsedResponse['token'];
      await loginWithAuthToken(authToken);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      throw CredentialsMismatchError('The provided credentials do not match.');
    } else {
      throw RequestError(response);
    }
  }

  Future<void> loginWithAuthToken(String authToken) async {
    await _setAuthToken(authToken);
    await refreshUser();
  }

  User getLoggedInUser() {
    return _loggedInUser;
  }

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void setSecureStorageService(SecureStorageService secureStorageService) {
    _secureStorageService = secureStorageService;
  }

  Future<void> refreshUser() async {
    if (_authToken == null) throw AuthTokenMissingError();

    Response response = await _authApiService.getUserWithAuthToken(_authToken);
    if (response.statusCode == HttpStatus.ok) {
      var user = User.fromJson(json.decode(response.body));
      _setUser(user);
    } else {
      throw RequestError(response);
    }
  }

  Future<bool> hasAuthToken() async {
    String authToken = await _getStoredAuthToken();
    return authToken != null;
  }

  void _setUser(User user) {
    _loggedInUser = user;
    _loggedInUserChangeSubject.add(user);
  }

  Future<void> _setAuthToken(String authToken) async {
    _authToken = authToken;
    await _storeAuthToken(authToken);
  }

  Future<void> _storeAuthToken(String authToken) {
    return _secureStorageService.set(
        key: STORAGE_AUTH_TOKEN_KEY, value: authToken);
  }

  Future<String> _getStoredAuthToken() async {
    String authToken =
        await this._secureStorageService.get(key: STORAGE_AUTH_TOKEN_KEY);
    if (authToken != null) _authToken = authToken;
    return authToken;
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
