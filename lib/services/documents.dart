import 'package:Openbook/services/httpie.dart';

class DocumentsApiService {
  HttpieService _httpService;

  static const guidelinesUrl =
      'https://raw.githubusercontent.com/OpenbookOrg/openbook-api/master/COMMUNITY_GUIDELINES.md';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  Future<String> getCommunityGuidelines() async {
    HttpieResponse response = await _httpService.get(guidelinesUrl);
    return response.body;
  }
}
