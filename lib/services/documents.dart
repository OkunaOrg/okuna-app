import 'package:Okuna/services/httpie.dart';

class DocumentsService {
  HttpieService _httpService;

  static const guidelinesUrl = 'https://okunaorg.github.io/okuna-api/COMMUNITY_GUIDELINES.md';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  Future<String> getCommunityGuidelines() async {
    HttpieResponse response = await _httpService.get(guidelinesUrl);
    return response.body;
  }
}
