import 'package:Okuna/services/httpie.dart';

class DocumentsService {
  HttpieService _httpService;

  static const guidelinesUrl = 'https://about.okuna.io/docs/COMMUNITY_GUIDELINES.md';
  static const privacyPolicyUrl = 'https://about.okuna.io/docs/PRIVACY_POLICY.md';
  static const termsOfUsePolicyUrl = 'https://about.okuna.io/docs/TERMS_OF_USE.md';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  Future<String> getCommunityGuidelines() async {
    HttpieResponse response = await _httpService.get(guidelinesUrl);
    return response.body;
  }

  Future<String> getPrivacyPolicy() async {
    HttpieResponse response = await _httpService.get(privacyPolicyUrl);
    return response.body;
  }

  Future<String> getTermsOfUse() async {
    HttpieResponse response = await _httpService.get(termsOfUsePolicyUrl);
    return response.body;
  }
}
