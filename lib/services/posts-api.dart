import 'dart:io';

import 'package:Openbook/models/post.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:meta/meta.dart';

class PostsApiService {
  HttpieService _httpService;

  String apiURL;

  static const GET_POSTS_PATH = 'api/posts/';
  static const CREATE_POST_PATH = 'api/posts/';

  void setHttpieService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getAllPosts(
      {List<int> listIds, List<int> circleIds, int maxId, int count}) {
    return _httpService.get('$apiURL$GET_POSTS_PATH',
        appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> createPost(
      {String text, List<int> circleIds, File image}) {
    Map<String, dynamic> body = {};

    if (image != null) {
      body['image'] = image;
    }

    if (text != null && text.length > 0) {
      body['text'] = text;
    }

    if (circleIds != null) {
      body['circle_id'] = circleIds.join(',');
    }

    return _httpService.putMultiform('$apiURL$CREATE_POST_PATH',
        body: body, appendAuthorizationToken: true);
  }
}
