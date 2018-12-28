import 'dart:io';

import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:meta/meta.dart';

class PostsApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const GET_POSTS_PATH = 'api/posts/';
  static const GET_TRENDING_POSTS_PATH = 'api/posts/trending/';
  static const CREATE_POST_PATH = 'api/posts/';
  static const DELETE_POST_PATH = 'api/posts/{postId}/';
  static const COMMENT_POST_PATH = 'api/posts/{postId}/comments/';
  static const DELETE_POST_COMMENT_PATH =
      'api/posts/{postId}/comments/{postCommentId}/';
  static const GET_POST_COMMENTS_PATH = 'api/posts/{postId}/comments/';
  static const REACT_TO_POST_PATH = 'api/posts/{postId}/reactions/';
  static const DELETE_POST_REACTION_PATH =
      'api/posts/{postId}/reactions/{postReactionId}/';
  static const GET_POST_REACTIONS_PATH = 'api/posts/{postId}/reactions/';
  static const GET_POST_REACTIONS_EMOJI_COUNT_PATH =
      'api/posts/{postId}/reactions/emoji-count/';
  static const GET_REACTION_EMOJI_GROUPS = 'api/posts/emojis/groups/';

  void setHttpieService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getTrendingPosts({bool authenticatedRequest = true}) {
    return _httpService.get('$apiURL$GET_TRENDING_POSTS_PATH',
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getTimelinePosts(
      {List<int> listIds,
      List<int> circleIds,
      int maxId,
      int count,
      String username,
      bool authenticatedRequest = true}) {
    Map<String, dynamic> queryParams = {};

    if (listIds != null && listIds.isNotEmpty) queryParams['list_id'] = listIds;

    if (circleIds != null && circleIds.isNotEmpty)
      queryParams['circle_id'] = circleIds;

    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    if (username != null) queryParams['username'] = username;

    return _httpService.get(_makeApiUrl(GET_POSTS_PATH),
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieStreamedResponse> createPost(
      {String text, List<int> circleIds, File image, File video}) {
    Map<String, dynamic> body = {};

    if (image != null) {
      body['image'] = image;
    }

    if (video != null) {
      body['video'] = video;
    }

    if (text != null && text.length > 0) {
      body['text'] = text;
    }

    if (circleIds != null && circleIds.length > 0) {
      body['circle_id'] = circleIds.join(',');
    }

    return _httpService.putMultiform(_makeApiUrl(CREATE_POST_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deletePostWithId(int postId) {
    String path = _makeDeletePostPath(postId);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getCommentsForPostWithId(int postId,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetPostCommentsPath(postId);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> commentPost(
      {@required int postId, @required String text}) {
    Map<String, dynamic> body = {'text': text};

    String path = _makeCommentPostPath(postId);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deletePostComment(
      {@required postCommentId, @required postId}) {
    String path = _makeDeletePostCommentPath(
        postCommentId: postCommentId, postId: postId);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReactionsForPostWithId(int postId,
      {int count, int maxId, int emojiId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    if (emojiId != null) queryParams['emoji_id'] = emojiId;

    String path = _makeGetPostReactionsPath(postId);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReactionsEmojiCountForPostWithId(int postId) {
    String path = _makeGetPostReactionsEmojiCountPath(postId);

    return _httpService.get(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> reactToPost(
      {@required int postId,
      @required int emojiId,
      @required int emojiGroupId}) {
    Map<String, dynamic> body = {'emoji_id': emojiId, 'group_id': emojiGroupId};

    String path = _makeReactToPostPath(postId);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deletePostReaction(
      {@required postReactionId, @required postId}) {
    String path = _makeDeletePostReactionPath(
        postReactionId: postReactionId, postId: postId);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReactionEmojiGroups() {
    String url = _makeApiUrl(GET_REACTION_EMOJI_GROUPS);
    return _httpService.get(url, appendAuthorizationToken: true);
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
    return _stringTemplateService.parse(DELETE_POST_COMMENT_PATH,
        {'postCommentId': postCommentId, 'postId': postId});
  }

  String _makeReactToPostPath(int postId) {
    return _stringTemplateService.parse(REACT_TO_POST_PATH, {'postId': postId});
  }

  String _makeGetPostReactionsPath(int postId) {
    return _stringTemplateService
        .parse(GET_POST_REACTIONS_PATH, {'postId': postId});
  }

  String _makeDeletePostReactionPath(
      {@required postReactionId, @required postId}) {
    return _stringTemplateService.parse(DELETE_POST_REACTION_PATH,
        {'postReactionId': postReactionId, 'postId': postId});
  }

  String _makeGetPostReactionsEmojiCountPath(int postId) {
    return _stringTemplateService
        .parse(GET_POST_REACTIONS_EMOJI_COUNT_PATH, {'postId': postId});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
