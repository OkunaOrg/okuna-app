import 'package:Openbook/services/http.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class AuthApiService {
  HttpService _httpService;

  String apiURL;

  static const CHECK_USERNAME_PATH = 'api/auth/username-check/';
  static const CHECK_EMAIL_PATH = 'api/auth/email-check/';
  static const REGISTER_PATH = 'api/auth/register/';

  void setHttpService(HttpService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<Response> checkUsernameIsAvailable({@required String username}) {
    return _httpService.postJSON('$apiURL$CHECK_USERNAME_PATH', body: {'username': username});
  }
}
