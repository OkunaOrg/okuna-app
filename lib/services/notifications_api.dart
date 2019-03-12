import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/string_template.dart';

class NotificationsApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const NOTIFICATIONS_PATH = 'api/notifications/';
  static const NOTIFICATIONS_READ_PATH = 'api/notifications/read/';
  static const NOTIFICATION_PATH = 'api/notifications/{notificationId}/';
  static const NOTIFICATION_READ_PATH =
      'api/notifications/{notificationId}/read/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getNotifications({int maxId, int count}) {
    Map<String, dynamic> queryParams = {};

    if (maxId != null) queryParams['max_id'] = maxId;

    if (count != null) queryParams['count'] = count;

    String url = _makeApiUrl(NOTIFICATIONS_PATH);
    return _httpService.get(url,
        appendAuthorizationToken: true, queryParameters: queryParams);
  }

  Future<HttpieResponse> readNotifications() {
    String url = _makeApiUrl(NOTIFICATIONS_READ_PATH);
    return _httpService.post(url, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteNotifications() {
    String url = _makeApiUrl(NOTIFICATIONS_PATH);
    return _httpService.delete(url, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteNotificationWithId(int notificationId) {
    String url = _makeNotificationPath(notificationId);
    return _httpService.delete(url, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> readNotificationWithId(int notificationId) {
    String url = _makeReadNotificationPath(notificationId);
    return _httpService.post(url, appendAuthorizationToken: true);
  }

  String _makeNotificationPath(int notificationId) {
    return _stringTemplateService
        .parse('$apiURL$NOTIFICATION_PATH', {'notificationId': notificationId});
  }

  String _makeReadNotificationPath(int notificationId) {
    return _stringTemplateService.parse(
        '$apiURL$NOTIFICATION_READ_PATH', {'notificationId': notificationId});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
