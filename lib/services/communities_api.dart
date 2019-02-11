import 'dart:io';

import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/string_template.dart';
import 'package:meta/meta.dart';

class CommunitiesApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const SEARCH_COMMUNITIES_PATH = 'api/communities/search/';
  static const GET_TRENDING_COMMUNITIES_PATH = 'api/communities/trending/';
  static const GET_JOINED_COMMUNITIES_PATH = 'api/communities/joined/';
  static const CREATE_COMMUNITY_PATH = 'api/communities/';
  static const DELETE_COMMUNITY_PATH = 'api/communities/{communityId}/';
  static const JOIN_COMMUNITY_PATH =
      'api/communities/{communityId}/members/join/';
  static const LEAVE_COMMUNITY_PATH =
      'api/communities/{communityId}/members/leave/';
  static const INVITE_USER_TO_COMMUNITY_PATH =
      'api/communities/{communityId}/members/invite/';
  static const BAN_COMMUNITY_USER_PATH =
      'api/communities/{communityId}/banned-users/ban/';
  static const UNBAN_COMMUNITY_USER_PATH =
      'api/communities/{communityId}/banned-users/unban/';
  static const COMMUNITY_AVATAR_PATH = 'api/communities/{communityId}/avatar/';
  static const COMMUNITY_COVER_PATH = 'api/communities/{communityId}/cover/';
  static const SEARCH_COMMUNITY_PATH = 'api/communities/{communityId}/search/';
  static const FAVORITE_COMMUNITY_PATH =
      'api/communities/{communityId}/favorite/';
  static const GET_FAVORITE_COMMUNITIES_PATH = 'api/communities/favorites/';
  static const GET_COMMUNITY_POSTS_PATH =
      'api/communities/{communityId}/posts/';
  static const CREATE_COMMUNITY_POST_PATH = 'api/communities/posts/';
  static const GET_COMMUNITY_MEMBERS_PATH =
      'api/communities/{communityId}/members/';
  static const GET_COMMUNITY_BANNED_USERS_PATH =
      'api/communities/{communityId}/banned-users/';
  static const GET_COMMUNITY_ADMINISTRATORS_PATH =
      'api/communities/{communityId}/administrators/';
  static const ADD_COMMUNITY_ADMINISTRATOR_PATH =
      'api/communities/{communityId}/administrators/';
  static const REMOVE_COMMUNITY_ADMINISTRATORS_PATH =
      'api/communities/{communityId}/administrators/{username}/';
  static const GET_COMMUNITY_MODERATORS_PATH =
      'api/communities/{communityId}/moderators/';
  static const ADD_COMMUNITY_MODERATOR_PATH =
      'api/communities/{communityId}/moderators/';
  static const REMOVE_COMMUNITY_MODERATORS_PATH =
      'api/communities/{communityId}/moderators/{username}/';
  static const CREATE_COMMUNITY_POSTS_PATH =
      'api/communities/{communityId}/posts/';

  void setHttpieService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getTrendingCommunities(
      {bool authenticatedRequest = true, String category}) {
    Map<String, dynamic> queryParams = {};

    if (category != null) queryParams['category'] = category;

    return _httpService.get('$apiURL$GET_TRENDING_COMMUNITIES_PATH',
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieStreamedResponse> createPostForCommunityWithId(int communityId,
      {String text, File image, File video}) {
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

    return _httpService.putMultiform(_makeApiUrl(CREATE_COMMUNITY_POST_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getPostsForCommunityWithId(int communityId,
      {int maxId, int count, bool authenticatedRequest = true}) {
    Map<String, dynamic> queryParams = {};

    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String url = _makeGetCommunityPostsPath(communityId);

    return _httpService.get(url,
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getCommunitiesWithQuery(
      {bool authenticatedRequest = true, @required String query}) {
    Map<String, dynamic> queryParams = {'query': query};

    return _httpService.get('$apiURL$SEARCH_COMMUNITIES_PATH',
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieStreamedResponse> createCommunity(
      {@required String name,
      @required String title,
      @required List<String> categories,
      @required String type,
      String color,
      String userAdjective,
      String usersAdjective,
      String description,
      String rules,
      File cover,
      File avatar}) {
    Map<String, dynamic> body = {
      'name': name,
      'title': title,
      'categories': categories,
      'type': type
    };

    if (avatar != null) {
      body['avatar'] = avatar;
    }

    if (cover != null) {
      body['cover'] = cover;
    }

    if (color != null) {
      body['color'] = color;
    }

    if (rules != null) {
      body['rules'] = rules;
    }

    if (description != null) {
      body['description'] = description;
    }

    if (userAdjective != null) {
      body['user_adjective'] = userAdjective;
    }

    if (usersAdjective != null) {
      body['users_adjective'] = usersAdjective;
    }

    return _httpService.putMultiform(_makeApiUrl(CREATE_COMMUNITY_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteCommunityWithId(int communityId) {
    String path = _makeDeleteCommunityPath(communityId);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getMembersForCommunityWithId(int communityId,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetCommunityMembersPath(communityId);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> inviteUserToCommunity(
      {@required int communityId, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeInviteUserToCommunityPath(communityId);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> joinCommunityWithId(int communityId) {
    String path = _makeJoinCommunityPath(communityId);
    return _httpService.putJSON(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> leaveCommunityWithId(int communityId) {
    String path = _makeLeaveCommunityPath(communityId);
    return _httpService.putJSON(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getModeratorsForCommunityWithId(int communityId,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetCommunityModeratorsPath(communityId);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> addCommunityModerator(
      {@required int communityId, @required String username}) {
    Map<String, dynamic> body = {'username': username};

    String path = _makeAddCommunityModeratorPath(communityId);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> removeCommunityModerator(
      {@required int communityId, @required String username}) {
    String path = _makeRemoveCommunityModeratorPath(communityId, username);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getAdministratorsForCommunityWithId(int communityId,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetCommunityAdministratorsPath(communityId);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> addCommunityAdministrator(
      {@required int communityId, @required String username}) {
    Map<String, dynamic> body = {'username': username};

    String path = _makeAddCommunityAdministratorPath(communityId);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> removeCommunityAdministrator(
      {@required int communityId, @required String username}) {
    String path = _makeRemoveCommunityAdministratorPath(communityId, username);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getBannedUsersForCommunityWithId(int communityId,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetCommunityBannedUsersPath(communityId);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> banCommunityUser(
      {@required int communityId, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeBanCommunityUserPath(communityId);
    return _httpService.postJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unbanCommunityUser(
      {@required int communityId, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeUnbanCommunityUserPath(communityId);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getFavoriteCommunities(
      {bool authenticatedRequest = true}) {
    return _httpService.get('$apiURL$GET_FAVORITE_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> favoriteCommunity({@required int communityId}) {
    String path = _makeFavoriteCommunityPath(communityId);
    return _httpService.putJSON(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unfavoriteCommunity({@required int communityId}) {
    String path = _makeFavoriteCommunityPath(communityId);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  String _makeInviteUserToCommunityPath(int communityId) {
    return _stringTemplateService
        .parse(INVITE_USER_TO_COMMUNITY_PATH, {'communityId': communityId});
  }

  String _makeUnbanCommunityUserPath(int communityId) {
    return _stringTemplateService
        .parse(UNBAN_COMMUNITY_USER_PATH, {'communityId': communityId});
  }

  String _makeBanCommunityUserPath(int communityId) {
    return _stringTemplateService
        .parse(BAN_COMMUNITY_USER_PATH, {'communityId': communityId});
  }

  String _makeDeleteCommunityPath(int communityId) {
    return _stringTemplateService
        .parse(DELETE_COMMUNITY_PATH, {'communityId': communityId});
  }

  String _makeAddCommunityAdministratorPath(int communityId) {
    return _stringTemplateService
        .parse(ADD_COMMUNITY_ADMINISTRATOR_PATH, {'communityId': communityId});
  }

  String _makeRemoveCommunityAdministratorPath(
      int communityId, String username) {
    return _stringTemplateService.parse(ADD_COMMUNITY_ADMINISTRATOR_PATH,
        {'communityId': communityId, 'username': username});
  }

  String _makeAddCommunityModeratorPath(int communityId) {
    return _stringTemplateService
        .parse(ADD_COMMUNITY_MODERATOR_PATH, {'communityId': communityId});
  }

  String _makeRemoveCommunityModeratorPath(int communityId, String username) {
    return _stringTemplateService.parse(ADD_COMMUNITY_MODERATOR_PATH,
        {'communityId': communityId, 'username': username});
  }

  String _makeGetCommunityPostsPath(int communityId) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_POSTS_PATH, {'communityId': communityId});
  }

  String _makeFavoriteCommunityPath(int communityId) {
    return _stringTemplateService
        .parse(FAVORITE_COMMUNITY_PATH, {'communityId': communityId});
  }

  String _makeJoinCommunityPath(int communityId) {
    return _stringTemplateService
        .parse(JOIN_COMMUNITY_PATH, {'communityId': communityId});
  }

  String _makeLeaveCommunityPath(int communityId) {
    return _stringTemplateService
        .parse(LEAVE_COMMUNITY_PATH, {'communityId': communityId});
  }

  String _makeGetCommunityMembersPath(int communityId) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_MEMBERS_PATH, {'communityId': communityId});
  }

  String _makeGetCommunityBannedUsersPath(int communityId) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_BANNED_USERS_PATH, {'communityId': communityId});
  }

  String _makeGetCommunityAdministratorsPath(int communityId) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_ADMINISTRATORS_PATH, {'communityId': communityId});
  }

  String _makeGetCommunityModeratorsPath(int communityId) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_MODERATORS_PATH, {'communityId': communityId});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
