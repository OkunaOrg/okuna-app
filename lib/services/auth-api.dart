import 'dart:io';

import 'package:Openbook/services/http.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class AuthApiService {
  HttpService _httpService;

  String apiURL;

  static const CHECK_USERNAME_PATH = 'api/auth/username-check/';
  static const CHECK_EMAIL_PATH = 'api/auth/email-check/';
  static const CREATE_ACCOUNT_PATH = 'api/auth/register/';

  void setHttpService(HttpService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<Response> checkUsernameIsAvailable({@required String username}) {
    return _httpService
        .postJSON('$apiURL$CHECK_USERNAME_PATH', body: {'username': username});
  }

  Future<Response> checkEmailIsAvailable({@required String email}) {
    return _httpService
        .postJSON('$apiURL$CHECK_EMAIL_PATH', body: {'email': email});
  }

  Future<StreamedResponse> createAccount({@required String email,
    @required String username,
    @required String name,
    @required String birthDate,
    @required String password, File avatar}) {


    Map<String, dynamic> body = {
      'email': email,
      'username': username,
      'name': name,
      'birth_date': birthDate,
      'password': password
    };

    if (avatar != null){
      body['avatar'] = avatar;
    }

    return _httpService.postMultiform('$apiURL$CREATE_ACCOUNT_PATH', body: body);
  }
}
