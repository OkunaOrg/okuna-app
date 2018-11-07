import 'dart:io';

import 'package:Openbook/models/post.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:meta/meta.dart';

class PostsApiService {
  HttpieService _httpService;

  String apiURL;

  static const GET_POSTS_PATH = 'api/posts/';
  static const CREATE_POST_PATH = 'api/posts/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getAllPosts(
      {List<int> listIds, List<int> circleIds, int maxId, int count}) {
    return _httpService.postJSON('$apiURL$GET_POSTS_PATH',
        appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> createPost(
      {@required String text, List<int> circleIds, File image}) {
    Map<String, dynamic> body = {
      'text': text,
    };

    if (image != null) {
      body['image'] = image;
    }

    if (circleIds != null) {
      body['circle_id'] = circleIds.join(',');
    }

    return _httpService.postMultiform('$apiURL$CREATE_POST_PATH',
        body: body, appendAuthorizationToken: true);
  }
}
