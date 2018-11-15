import 'dart:io';

import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:meta/meta.dart';

class PostsApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const GET_POSTS_PATH = 'api/posts/';
  static const CREATE_POST_PATH = 'api/posts/';
  static const DELETE_POST_PATH = 'api/posts/{postId}/';
  static const COMMENT_POST_PATH = 'api/posts/{postId}/comments/';
  static const DELETE_POST_COMMENT_PATH =
      'api/posts/{postId}/comments/{postCommentId}';
  static const GET_POST_COMMENTS_PATH = 'api/posts/{postId}/comments/';

  void setHttpieService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getTimelinePosts(
      {List<int> listIds, List<int> circleIds, int maxId, int count}) {
    Map<String, dynamic> queryParams = {};

    if (listIds != null) queryParams['lists_ids'] = listIds;

    if (circleIds != null) queryParams['circle_ids'] = circleIds;

    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    return _httpService.get(_makeApiUrl(GET_POSTS_PATH),
        queryParameters: queryParams, appendAuthorizationToken: true);
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

    return _httpService.putMultiform(_makeApiUrl(CREATE_POST_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> commentPost(
      {@required int postId, @required String text}) {
    Map<String, dynamic> body = {'text': text};

    String path = _makeCommentPostPath(postId);
    return _httpService.postJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deletePostWithId(int postId) {
    String path = _makeDeletePostPath(postId);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getCommentsForPostWithId(int postId,
      {int count, int minId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (minId != null) queryParams['min_id'] = minId;

    String path = _makeGetPostCommentsPath(postId);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deletePostComment(
      {@required postCommentId, @required postId}) {
    String path = _makeDeletePostCommentPath(
        postCommentId: postCommentId, postId: postId);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  String _makeDeletePostPath(int postId) {
    return _stringTemplateService.parse(DELETE_POST_PATH, {'postId': postId});
  }

  String _makeCommentPostPath(int postId) {
    return _stringTemplateService.parse(COMMENT_POST_PATH, {'postId': postId});
  }

  String _makeGetPostCommentsPath(int postId) {
    return _stringTemplateService
        .parse(GET_POST_COMMENTS_PATH, {'postId': postId});
  }

  String _makeDeletePostCommentPath(
      {@required postCommentId, @required postId}) {
    return _stringTemplateService.parse(
        COMMENT_POST_PATH, {'postCommentId': postCommentId, 'postId': postId});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
