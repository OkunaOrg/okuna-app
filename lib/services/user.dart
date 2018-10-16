import 'dart:convert';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/services/auth-api.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  AuthApiService _authApiService;

  Stream<User> get loggedInUserChange => _loggedInUserChangeSubject.stream;

  User _loggedInUser;

  final _loggedInUserChangeSubject = BehaviorSubject<User>();

  Future<void> loginWithCredentials(
      {@required String username, @required String password}) {
    return _authApiService
        .loginWithCredentials(username: username, password: password)
        .then((Response response) {
      if (response.statusCode == 200) {
        var user = User.fromJson(json.decode(response.body));
        _setUser(user);
      } else if (response.statusCode == 401) {
        throw CredentialsMismatchError(
            'The provided credentials do not match.');
      } else {
        throw 'Server error';
      }
    });
  }

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void _setUser(User user) {
    _loggedInUser = user;
    _loggedInUserChangeSubject.add(user);
  }

  User getLoggedInUser(){
    return _loggedInUser;
  }
}

class CredentialsMismatchError implements Exception {
  final String msg;

  const CredentialsMismatchError(this.msg);

  String toString() => 'CredentialsMismatchError: $msg';
}
