import 'package:Openbook/services/http.dart';

class AuthApiService {
  HttpService _httpService;

  void setHttpService(HttpService httpService) {
    _httpService = httpService;
  }
}
