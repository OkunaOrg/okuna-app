import 'package:Openbook/services/httpie.dart';

class DocumentsService {
  HttpieService _httpService;

  static const guidelinesUrl = 'https://openbookorg.github.io/openbook-api/COMMUNITY_GUIDELINES.md';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  Future<String> getCommunityGuidelines() async {
    Map<String, String> headers = {
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36',
      'Accept' :'text/plain; charset=utf-8',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
      'accept-encoding': 'gzip, deflate',
    };

    HttpieResponse response = await _httpService.get(guidelinesUrl);
    return response.body;
  }
}
