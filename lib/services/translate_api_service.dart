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

  Future<HttpieResponse> translateText({String text, String sourceLanguageCode, String targetLanguageCode}) {
    var body = {};
    if (text != null && text != '') {
      body = {'text': text};
    }

    if (sourceLanguageCode != null && sourceLanguageCode != '') {
      body['source_language_code'] = sourceLanguageCode;
    }

    if (targetLanguageCode != null && targetLanguageCode != '') {
      body['target_language_code'] = targetLanguageCode;
    }

    return this
        ._httpService
        .postJSON('$apiURL$TRANSLATE_PATH', body: body, appendAuthorizationToken: true);
  }
}
