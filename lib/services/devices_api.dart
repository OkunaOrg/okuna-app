import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:meta/meta.dart';

class DevicesApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const DEVICES_PATH = 'api/devices/';
  static const DEVICE_PATH = 'api/devices/{deviceId}/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getDevices() {
    String url = _makeApiUrl(DEVICES_PATH);
    return _httpService.get(url, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteDevices() {
    String url = _makeApiUrl(DEVICES_PATH);
    return _httpService.delete(url, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> createDevice(
      {@required String uuid,
      String name,
      String oneSignalPlayerId,
      bool notificationsEnabled}) {
    String url = _makeApiUrl(DEVICE_PATH);
    Map<String, dynamic> body = {'uuid': uuid};

    if (name != null) body['name'] = name;

    if (oneSignalPlayerId != null)
      body['one_signal_player_id'] = oneSignalPlayerId;

    if (notificationsEnabled != null)
      body['notifications_enabled'] = notificationsEnabled;

    return _httpService.putJSON(url,
        appendAuthorizationToken: true, body: body);
  }

  Future<HttpieResponse> updateDeviceWithId(int deviceId,
      {String name, String oneSignalPlayerId, bool notificationsEnabled}) {
    String url = _makeApiUrl(DEVICE_PATH);
    Map<String, dynamic> body = {};

    if (name != null) body['name'] = name;

    if (oneSignalPlayerId != null)
      body['one_signal_player_id'] = oneSignalPlayerId;

    if (notificationsEnabled != null)
      body['notifications_enabled'] = notificationsEnabled;

    return _httpService.patchJSON(url,
        appendAuthorizationToken: true, body: body);
  }

  Future<HttpieResponse> deleteDeviceWithId(int deviceId) {
    String url = _makeDeleteDevicePath(deviceId);
    return _httpService.delete(url, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getDeviceWithId(int deviceId) {
    String url = _makeGetDevicePath(deviceId);
    return _httpService.get(url, appendAuthorizationToken: true);
  }

  String _makeDeleteDevicePath(int deviceId) {
    return _stringTemplateService
        .parse('$apiURL$DEVICE_PATH', {'deviceId': deviceId});
  }

  String _makeGetDevicePath(int deviceId) {
    return _stringTemplateService
        .parse('$apiURL$DEVICE_PATH', {'deviceId': deviceId});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
