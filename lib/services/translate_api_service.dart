import 'package:Openbook/services/httpie.dart';

class TranslateApiService {
  HttpieService _httpService;

  String apiURL;

  static const TRANSLATE_PATH = 'api/translate/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
