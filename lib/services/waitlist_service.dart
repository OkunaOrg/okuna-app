import 'dart:io';
import 'package:Openbook/services/httpie.dart';

class WaitlistApiService {
  HttpieService _httpService;

  String openbookSocialApiURL;

  static const MAILCHIMP_SUBSCRIBE_PATH = 'waitlist/subscribe/';

  void setOpenbookSocialApiURL(String newApiURL) {
    openbookSocialApiURL = newApiURL;
  }

  Future<HttpieResponse> subscribeToBetaWaitlist({String email}) {
    var body = {};
    if (email != null && email != '') {
      body['email'] = email;
    }
    return this
        ._httpService
        .postJSON('$openbookSocialApiURL$MAILCHIMP_SUBSCRIBE_PATH', body: body);
  }

}