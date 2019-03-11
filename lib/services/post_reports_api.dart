import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:meta/meta.dart';

class PostReportsApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const CREATE_POST_REPORT_PATH = 'api/posts/{postId}/reports/';
  static const GET_REPORTS_FOR_POST_PATH = 'api/posts/{postId}/reports/';
  static const GET_REPORTED_POSTS_FOR_COMMUNITY_PATH = 'api/communities/{communityName}/posts/reports/';
  static const CONFIRM_POST_REPORT_PATH = 'api/posts/{postId}/reports/{reportId}/confirm/';
  static const REJECT_POST_REPORT_PATH = 'api/posts/{postId}/reports/{reportId}/reject/';
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

  Future<HttpieResponse> getReportsForPost({@required int postId}) {

    String path = _makeGetPostReportsPath(postId);
    return _httpService.get(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> createPostReport(
      {@required postId, @required String categoryName, String comment}) {
    Map<String, dynamic> body = {};

    if (categoryName != null) {
      body['category_name'] = categoryName;
    }

    if (comment != null) {
      body['comment'] = comment;
    }

    String path = _makeCreatePostReportPath(postId);

    return _httpService.putMultiform(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> confirmPostReport(int postId, int reportId) {
    String path = _makeConfirmPostReportPath(postId, reportId);

    return _httpService.post(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReportCategories() {
    return _httpService.get(_makeApiUrl(GET_REPORT_CATEGORIES), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> rejectPostReport(int postId, int reportId) {
    String path = _makeRejectPostReportPath(postId, reportId);

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

  String _makeConfirmPostReportPath(int postId, int reportId) {
    return _stringTemplateService.parse(CONFIRM_POST_REPORT_PATH, {'postId': postId, 'reportId': reportId});
  }

  String _makeRejectPostReportPath(int postId, int reportId) {
    return _stringTemplateService.parse(REJECT_POST_REPORT_PATH, {'postId': postId, 'reportId': reportId});
  }

  String _makeGetPostReportsPath(int postId) {
    return _stringTemplateService
        .parse(GET_REPORTS_FOR_POST_PATH, {'postId': postId});
  }

  String _makeCreatePostReportPath(int postId) {
    return _stringTemplateService
        .parse(CREATE_POST_REPORT_PATH, {'postId': postId});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
