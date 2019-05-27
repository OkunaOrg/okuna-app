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
  static const EDIT_POST_PATH = 'api/posts/{postUuid}/';
  static const POST_PATH = 'api/posts/{postUuid}/';
  static const OPEN_POST_PATH = 'api/posts/{postUuid}/open/';
  static const CLOSE_POST_PATH = 'api/posts/{postUuid}/close/';
  static const COMMENT_POST_PATH = 'api/posts/{postUuid}/comments/';
  static const EDIT_COMMENT_POST_PATH =
      'api/posts/{postUuid}/comments/{postCommentId}/';
  static const REPLY_COMMENT_POST_PATH =
      'api/posts/{postUuid}/comments/{postCommentId}/replies/';
  static const MUTE_POST_PATH = 'api/posts/{postUuid}/notifications/mute/';
  static const UNMUTE_POST_PATH = 'api/posts/{postUuid}/notifications/unmute/';
  static const REPORT_POST_PATH = 'api/posts/{postUuid}/report/';
  static const DELETE_POST_COMMENT_PATH =
      'api/posts/{postUuid}/comments/{postCommentId}/';
  static const REPORT_POST_COMMENT_PATH =
      'api/posts/{postUuid}/comments/{postCommentId}/report/';
  static const GET_POST_COMMENTS_PATH = 'api/posts/{postUuid}/comments/';
  static const DISABLE_POST_COMMENTS_PATH =
      'api/posts/{postUuid}/comments/disable/';
  static const ENABLE_POST_COMMENTS_PATH =
      'api/posts/{postUuid}/comments/enable/';
  static const REACT_TO_POST_PATH = 'api/posts/{postUuid}/reactions/';
  static const DELETE_POST_REACTION_PATH =
      'api/posts/{postUuid}/reactions/{postReactionId}/';
  static const GET_POST_REACTIONS_PATH = 'api/posts/{postUuid}/reactions/';
  static const GET_POST_REACTIONS_EMOJI_COUNT_PATH =
      'api/posts/{postUuid}/reactions/emoji-count/';
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

  Future<HttpieStreamedResponse> editPost(
      {@required String postUuid, String text}) {
    Map<String, dynamic> body = {};

    body['post_uuid'] = postUuid;

    if (text != null && text.length > 0) {
      body['text'] = text;
    }

    String path = _makePostPath(postUuid);

    return _httpService.patchMultiform(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getPostWithUuid(String postUuid) {
    String path = _makePostPath(postUuid);

    return _httpService.get(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deletePostWithUuid(String postUuid) {
    String path = _makePostPath(postUuid);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getCommentsForPostWithUuid(String postUuid,
      {int countMax, int maxId, int countMin, int minId, String sort}) {
    Map<String, dynamic> queryParams = {};
    if (countMax != null) queryParams['count_max'] = countMax;
    if (countMin != null) queryParams['count_min'] = countMin;

    if (maxId != null) queryParams['max_id'] = maxId;
    if (minId != null) queryParams['min_id'] = minId;
    if (sort != null) queryParams['sort'] = sort;

    String path = _makeGetPostCommentsPath(postUuid);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getRepliesForCommentWithIdForPostWithUuid(
      String postUuid, int postCommentId,
      {int countMax, int maxId, int countMin, int minId, String sort}) {
    Map<String, dynamic> queryParams = {};
    if (countMax != null) queryParams['count_max'] = countMax;
    if (countMin != null) queryParams['count_min'] = countMin;

    if (maxId != null) queryParams['max_id'] = maxId;
    if (minId != null) queryParams['min_id'] = minId;
    if (sort != null) queryParams['sort'] = sort;

    String path = _makeGetReplyCommentsPostPath(postUuid, postCommentId);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> commentPost(
      {@required String postUuid, @required String text}) {
    Map<String, dynamic> body = {'text': text};

    String path = _makeCommentPostPath(postUuid);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> editPostComment(
      {@required String postUuid,
      @required int postCommentId,
      @required String text}) {
    Map<String, dynamic> body = {'text': text};

    String path = _makeEditCommentPostPath(postUuid, postCommentId);
    return _httpService.patchJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> replyPostComment(
      {@required String postUuid,
      @required int postCommentId,
      @required String text}) {
    Map<String, dynamic> body = {'text': text};

    String path = _makeReplyCommentPostPath(postUuid, postCommentId);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deletePostComment(
      {@required postCommentId, @required postUuid}) {
    String path = _makeDeletePostCommentPath(
        postCommentId: postCommentId, postUuid: postUuid);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReactionsForPostWithUuid(String postUuid,
      {int count, int maxId, int emojiId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    if (emojiId != null) queryParams['emoji_id'] = emojiId;

    String path = _makeGetPostReactionsPath(postUuid);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReactionsEmojiCountForPostWithUuid(
      String postUuid) {
    String path = _makeGetPostReactionsEmojiCountPath(postUuid);

    return _httpService.get(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> reactToPost(
      {@required String postUuid,
      @required int emojiId,
      @required int emojiGroupId}) {
    Map<String, dynamic> body = {'emoji_id': emojiId, 'group_id': emojiGroupId};

    String path = _makeReactToPostPath(postUuid);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deletePostReaction(
      {@required postReactionId, @required postUuid}) {
    String path = _makeDeletePostReactionPath(
        postReactionId: postReactionId, postUuid: postUuid);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> mutePostWithUuid(String postUuid) {
    String path = _makeMutePostPath(postUuid);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unmutePostWithUuid(String postUuid) {
    String path = _makeUnmutePostPath(postUuid);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> disableCommentsForPostWithUuidPost(String postUuid) {
    String path = _makeDisableCommentsForPostPath(postUuid);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> enableCommentsForPostWithUuidPost(String postUuid) {
    String path = _makeEnableCommentsForPostPath(postUuid);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> openPostWithUuid(String postUuid) {
    String path = _makeOpenPostPath(postUuid);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> closePostWithUuid(String postUuid) {
    String path = _makeClosePostPath(postUuid);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getReactionEmojiGroups() {
    String url = _makeApiUrl(GET_REACTION_EMOJI_GROUPS);
    return _httpService.get(url, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> reportPostComment(
      {@required int postCommentId,
      @required String postUuid,
      @required int moderationCategoryId,
      String description}) {
    String path = _makeReportPostCommentPath(
        postCommentId: postCommentId, postUuid: postUuid);

    Map<String, dynamic> body = {
      'category_id': moderationCategoryId.toString()
    };

    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }

    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> reportPost(
      {@required String postUuid,
      @required int moderationCategoryId,
      String description}) {
    String path = _makeReportPostPath(postUuid: postUuid);

    Map<String, dynamic> body = {
      'category_id': moderationCategoryId.toString()
    };

    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }

    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  String _makePostPath(String postUuid) {
    return _stringTemplateService.parse(POST_PATH, {'postUuid': postUuid});
  }

  String _makeMutePostPath(String postUuid) {
    return _stringTemplateService.parse(MUTE_POST_PATH, {'postUuid': postUuid});
  }

  String _makeUnmutePostPath(String postUuid) {
    return _stringTemplateService
        .parse(UNMUTE_POST_PATH, {'postUuid': postUuid});
  }

  String _makeDisableCommentsForPostPath(String postUuid) {
    return _stringTemplateService
        .parse(DISABLE_POST_COMMENTS_PATH, {'postUuid': postUuid});
  }

  String _makeEnableCommentsForPostPath(String postUuid) {
    return _stringTemplateService
        .parse(ENABLE_POST_COMMENTS_PATH, {'postUuid': postUuid});
  }

  String _makeOpenPostPath(String postUuid) {
    return _stringTemplateService.parse(OPEN_POST_PATH, {'postUuid': postUuid});
  }

  String _makeClosePostPath(String postUuid) {
    return _stringTemplateService
        .parse(CLOSE_POST_PATH, {'postUuid': postUuid});
  }

  String _makeCommentPostPath(String postUuid) {
    return _stringTemplateService
        .parse(COMMENT_POST_PATH, {'postUuid': postUuid});
  }

  String _makeEditCommentPostPath(String postUuid, int postCommentId) {
    return _stringTemplateService.parse(EDIT_COMMENT_POST_PATH,
        {'postUuid': postUuid, 'postCommentId': postCommentId});
  }

  String _makeReplyCommentPostPath(String postUuid, int postCommentId) {
    return _stringTemplateService.parse(REPLY_COMMENT_POST_PATH,
        {'postUuid': postUuid, 'postCommentId': postCommentId});
  }

  String _makeGetReplyCommentsPostPath(String postUuid, int postCommentId) {
    return _stringTemplateService.parse(REPLY_COMMENT_POST_PATH,
        {'postUuid': postUuid, 'postCommentId': postCommentId});
  }

  String _makeGetPostCommentsPath(String postUuid) {
    return _stringTemplateService
        .parse(GET_POST_COMMENTS_PATH, {'postUuid': postUuid});
  }

  String _makeDeletePostCommentPath(
      {@required postCommentId, @required postUuid}) {
    return _stringTemplateService.parse(DELETE_POST_COMMENT_PATH,
        {'postCommentId': postCommentId, 'postUuid': postUuid});
  }

  String _makeReactToPostPath(String postUuid) {
    return _stringTemplateService
        .parse(REACT_TO_POST_PATH, {'postUuid': postUuid});
  }

  String _makeGetPostReactionsPath(String postUuid) {
    return _stringTemplateService
        .parse(GET_POST_REACTIONS_PATH, {'postUuid': postUuid});
  }

  String _makeDeletePostReactionPath(
      {@required postReactionId, @required postUuid}) {
    return _stringTemplateService.parse(DELETE_POST_REACTION_PATH,
        {'postReactionId': postReactionId, 'postUuid': postUuid});
  }

  String _makeGetPostReactionsEmojiCountPath(String postUuid) {
    return _stringTemplateService
        .parse(GET_POST_REACTIONS_EMOJI_COUNT_PATH, {'postUuid': postUuid});
  }

  String _makeReportPostCommentPath(
      {@required int postCommentId, @required String postUuid}) {
    return _stringTemplateService.parse(REPORT_POST_COMMENT_PATH,
        {'postCommentId': postCommentId, 'postUuid': postUuid});
  }

  String _makeReportPostPath({@required postUuid}) {
    return _stringTemplateService
        .parse(REPORT_POST_PATH, {'postUuid': postUuid});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
