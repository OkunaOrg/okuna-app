import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:meta/meta.dart';

class PostReportsApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const CREATE_POST_REPORT_PATH = 'api/posts/{postUuid}/reports/';
  static const GET_REPORTS_FOR_POST_PATH = 'api/posts/{postUuid}/reports/';
  static const GET_REPORTED_POSTS_FOR_COMMUNITY_PATH = 'api/communities/{communityName}/posts/reports/';
  static const CONFIRM_POST_REPORT_PATH = 'api/posts/{postUuid}/reports/{reportId}/confirm/';
  static const REJECT_POST_REPORT_PATH = 'api/posts/{postUuid}/reports/{reportId}/reject/';
  static const GET_REPORT_CATEGORIES = 'api/reports/categories/';


  void setHttpieService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getReportsForPost({@required String postUuid}) {

    String path = _makeGetPostReportsPath(postUuid);
    return _httpService.get(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> createPostReport(
      {@required postUuid, @required String categoryName, String comment}) {
    Map<String, dynamic> body = {};

    if (categoryName != null) {
      body['category_name'] = categoryName;
    }

    if (comment != null) {
      body['comment'] = comment;
    }

    String path = _makeCreatePostReportPath(postUuid);

    return _httpService.putMultiform(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> confirmPostReport(String postUuid, int reportId) {
    String path = _makeConfirmPostReportPath(postUuid, reportId);

    return _httpService.post(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReportCategories() {
    return _httpService.get(_makeApiUrl(GET_REPORT_CATEGORIES), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> rejectPostReport(String postUuid, int reportId) {
    String path = _makeRejectPostReportPath(postUuid, reportId);

    return _httpService.post(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReportedPostsForCommunityWithName(String communityName) {
    String url = _makeGetCommunityReportedPostsPath(communityName);

    return _httpService.get(_makeApiUrl(url),
        appendAuthorizationToken: true);
  }

  String _makeGetCommunityReportedPostsPath(String communityName) {
    return _stringTemplateService
        .parse(GET_REPORTED_POSTS_FOR_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeConfirmPostReportPath(String postUuid, int reportId) {
    return _stringTemplateService.parse(CONFIRM_POST_REPORT_PATH, {'postUuid': postUuid, 'reportId': reportId});
  }

  String _makeRejectPostReportPath(String postUuid, int reportId) {
    return _stringTemplateService.parse(REJECT_POST_REPORT_PATH, {'postUuid': postUuid, 'reportId': reportId});
  }

  String _makeGetPostReportsPath(String postUuid) {
    return _stringTemplateService
        .parse(GET_REPORTS_FOR_POST_PATH, {'postUuid': postUuid});
  }

  String _makeCreatePostReportPath(String postUuid) {
    return _stringTemplateService
        .parse(CREATE_POST_REPORT_PATH, {'postUuid': postUuid});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
