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
  static const CHECK_COMMUNITY_NAME_PATH = 'api/communities/name-check/';
  static const CREATE_COMMUNITY_PATH = 'api/communities/';
  static const DELETE_COMMUNITY_PATH = 'api/communities/{communityName}/';
  static const UPDATE_COMMUNITY_PATH = 'api/communities/{communityName}/';
  static const GET_COMMUNITY_PATH = 'api/communities/{communityName}/';
  static const JOIN_COMMUNITY_PATH =
      'api/communities/{communityName}/members/join/';
  static const LEAVE_COMMUNITY_PATH =
      'api/communities/{communityName}/members/leave/';
  static const INVITE_USER_TO_COMMUNITY_PATH =
      'api/communities/{communityName}/members/invite/';
  static const BAN_COMMUNITY_USER_PATH =
      'api/communities/{communityName}/banned-users/ban/';
  static const UNBAN_COMMUNITY_USER_PATH =
      'api/communities/{communityName}/banned-users/unban/';
  static const SEARCH_COMMUNITY_BANNED_USERS_PATH =
      'api/communities/{communityName}/banned-users/search/';
  static const COMMUNITY_AVATAR_PATH =
      'api/communities/{communityName}/avatar/';
  static const COMMUNITY_COVER_PATH = 'api/communities/{communityName}/cover/';
  static const SEARCH_COMMUNITY_PATH =
      'api/communities/{communityName}/search/';
  static const FAVORITE_COMMUNITY_PATH =
      'api/communities/{communityName}/favorite/';
  static const GET_FAVORITE_COMMUNITIES_PATH = 'api/communities/favorites/';
  static const GET_ADMINISTRATED_COMMUNITIES_PATH =
      'api/communities/administrated/';
  static const GET_MODERATED_COMMUNITIES_PATH = 'api/communities/moderated/';
  static const GET_COMMUNITY_POSTS_PATH =
      'api/communities/{communityName}/posts/';
  static const CREATE_COMMUNITY_POST_PATH = 'api/communities/posts/';
  static const GET_COMMUNITY_MEMBERS_PATH =
      'api/communities/{communityName}/members/';
  static const SEARCH_COMMUNITY_MEMBERS_PATH =
      'api/communities/{communityName}/members/search/';
  static const GET_COMMUNITY_BANNED_USERS_PATH =
      'api/communities/{communityName}/banned-users/';
  static const GET_COMMUNITY_ADMINISTRATORS_PATH =
      'api/communities/{communityName}/administrators/';
  static const SEARCH_COMMUNITY_ADMINISTRATORS_PATH =
      'api/communities/{communityName}/administrators/search/';
  static const ADD_COMMUNITY_ADMINISTRATOR_PATH =
      'api/communities/{communityName}/administrators/';
  static const REMOVE_COMMUNITY_ADMINISTRATORS_PATH =
      'api/communities/{communityName}/administrators/{username}/';
  static const GET_COMMUNITY_MODERATORS_PATH =
      'api/communities/{communityName}/moderators/';
  static const SEARCH_COMMUNITY_MODERATORS_PATH =
      'api/communities/{communityName}/moderators/search/';
  static const ADD_COMMUNITY_MODERATOR_PATH =
      'api/communities/{communityName}/moderators/';
  static const REMOVE_COMMUNITY_MODERATORS_PATH =
      'api/communities/{communityName}/moderators/{username}/';
  static const CREATE_COMMUNITY_POSTS_PATH =
      'api/communities/{communityName}/posts/';

  void setHttpieService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> checkNameIsAvailable({@required String name}) {
    return _httpService.postJSON('$apiURL$CHECK_COMMUNITY_NAME_PATH',
        body: {'name': name}, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getTrendingCommunities(
      {bool authenticatedRequest = true, String category}) {
    Map<String, dynamic> queryParams = {};

    if (category != null) queryParams['category'] = category;

    return _httpService.get('$apiURL$GET_TRENDING_COMMUNITIES_PATH',
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieStreamedResponse> createPostForCommunityWithId(
      String communityName,
      {String text,
      File image,
      File video}) {
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

  Future<HttpieResponse> getPostsForCommunityWithName(String communityName,
      {int maxId, int count, bool authenticatedRequest = true}) {
    Map<String, dynamic> queryParams = {};

    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String url = _makeGetCommunityPostsPath(communityName);

    return _httpService.get(_makeApiUrl(url),
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

  Future<HttpieResponse> getCommunityWithName(String name,
      {bool authenticatedRequest = true}) {
    String url = _makeGetCommunityPath(name);
    return _httpService.get(_makeApiUrl(url),
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieStreamedResponse> createCommunity(
      {@required String name,
      @required String title,
      @required List<String> categories,
      @required String type,
      bool invitesEnabled,
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

    if (userAdjective != null && userAdjective.isNotEmpty) {
      body['user_adjective'] = userAdjective;
    }

    if (usersAdjective != null && usersAdjective.isNotEmpty) {
      body['users_adjective'] = usersAdjective;
    }

    if (invitesEnabled != null) {
      body['invites_enabled'] = invitesEnabled;
    }

    return _httpService.putMultiform(_makeApiUrl(CREATE_COMMUNITY_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateCommunityWithName(String communityName,
      {String name,
      String title,
      List<String> categories,
      bool invitesEnabled,
      String type,
      String color,
      String userAdjective,
      String usersAdjective,
      String description,
      String rules}) {
    Map<String, dynamic> body = {};

    if (name != null) {
      body['name'] = name;
    }

    if (title != null) {
      body['title'] = title;
    }

    if (categories != null) {
      body['categories'] = categories;
    }

    if (type != null) {
      body['type'] = type;
    }

    if (invitesEnabled != null) {
      body['invites_enabled'] = invitesEnabled;
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

    if (userAdjective != null && userAdjective.isNotEmpty) {
      body['user_adjective'] = userAdjective;
    }

    if (usersAdjective != null && usersAdjective.isNotEmpty) {
      body['users_adjective'] = usersAdjective;
    }

    return _httpService.patchMultiform(
        _makeApiUrl(_makeUpdateCommunityPath(communityName)),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateAvatarForCommunityWithName(
      String communityName,
      {File avatar}) {
    Map<String, dynamic> body = {'avatar': avatar};

    return _httpService.putMultiform(
        _makeApiUrl(_makeCommunityAvatarPath(communityName)),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteAvatarForCommunityWithName(
      String communityName) {
    return _httpService.delete(
        _makeApiUrl(_makeCommunityAvatarPath(communityName)),
        appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateCoverForCommunityWithName(
      String communityName,
      {File cover}) {
    Map<String, dynamic> body = {'cover': cover};

    return _httpService.putMultiform(
        _makeApiUrl(_makeCommunityCoverPath(communityName)),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteCoverForCommunityWithName(String communityName) {
    return _httpService.delete(
        _makeApiUrl(_makeCommunityCoverPath(communityName)),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteCommunityWithName(String communityName) {
    String path = _makeDeleteCommunityPath(communityName);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getMembersForCommunityWithId(String communityName,
      {int count, int maxId, List<String> exclude}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    if (exclude != null && exclude.isNotEmpty) queryParams['exclude'] = exclude;

    String path = _makeGetCommunityMembersPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchMembers(
      {@required String communityName,
      @required String query,
      List<String> exclude}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (exclude != null && exclude.isNotEmpty) queryParams['exclude'] = exclude;

    String path = _makeSearchCommunityMembersPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> inviteUserToCommunity(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeInviteUserToCommunityPath(communityName);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getJoinedCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_JOINED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  Future<HttpieResponse> joinCommunityWithId(String communityName) {
    String path = _makeJoinCommunityPath(communityName);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> leaveCommunityWithId(String communityName) {
    String path = _makeLeaveCommunityPath(communityName);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getModeratorsForCommunityWithId(String communityName,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetCommunityModeratorsPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchModerators({
    @required String communityName,
    @required String query,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    String path = _makeSearchCommunityModeratorsPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> addCommunityModerator(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};

    String path = _makeAddCommunityModeratorPath(communityName);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> removeCommunityModerator(
      {@required String communityName, @required String username}) {
    String path = _makeRemoveCommunityModeratorPath(communityName, username);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getAdministratorsForCommunityWithName(
      String communityName,
      {int count,
      int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetCommunityAdministratorsPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchAdministrators({
    @required String communityName,
    @required String query,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    String path = _makeSearchCommunityAdministratorsPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> addCommunityAdministrator(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};

    String path = _makeAddCommunityAdministratorPath(communityName);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> removeCommunityAdministrator(
      {@required String communityName, @required String username}) {
    String path =
        _makeRemoveCommunityAdministratorPath(communityName, username);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getBannedUsersForCommunityWithId(String communityName,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetCommunityBannedUsersPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchBannedUsers({
    @required String communityName,
    @required String query,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    String path = _makeSearchCommunityBannedUsersPath(communityName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> banCommunityUser(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeBanCommunityUserPath(communityName);
    return _httpService.postJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unbanCommunityUser(
      {@required String communityName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeUnbanCommunityUserPath(communityName);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getFavoriteCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_FAVORITE_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  Future<HttpieResponse> favoriteCommunity({@required String communityName}) {
    String path = _makeFavoriteCommunityPath(communityName);
    return _httpService.putJSON(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unfavoriteCommunity({@required String communityName}) {
    String path = _makeFavoriteCommunityPath(communityName);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getAdministratedCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_ADMINISTRATED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  Future<HttpieResponse> getModeratedCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_MODERATED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  String _makeInviteUserToCommunityPath(String communityName) {
    return _stringTemplateService
        .parse(INVITE_USER_TO_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeUnbanCommunityUserPath(String communityName) {
    return _stringTemplateService
        .parse(UNBAN_COMMUNITY_USER_PATH, {'communityName': communityName});
  }

  String _makeBanCommunityUserPath(String communityName) {
    return _stringTemplateService
        .parse(BAN_COMMUNITY_USER_PATH, {'communityName': communityName});
  }

  String _makeSearchCommunityBannedUsersPath(String communityName) {
    return _stringTemplateService.parse(
        SEARCH_COMMUNITY_BANNED_USERS_PATH, {'communityName': communityName});
  }

  String _makeDeleteCommunityPath(String communityName) {
    return _stringTemplateService
        .parse(DELETE_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeGetCommunityPath(String communityName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeAddCommunityAdministratorPath(String communityName) {
    return _stringTemplateService.parse(
        ADD_COMMUNITY_ADMINISTRATOR_PATH, {'communityName': communityName});
  }

  String _makeRemoveCommunityAdministratorPath(
      String communityName, String username) {
    return _stringTemplateService.parse(REMOVE_COMMUNITY_ADMINISTRATORS_PATH,
        {'communityName': communityName, 'username': username});
  }

  String _makeAddCommunityModeratorPath(String communityName) {
    return _stringTemplateService
        .parse(ADD_COMMUNITY_MODERATOR_PATH, {'communityName': communityName});
  }

  String _makeRemoveCommunityModeratorPath(
      String communityName, String username) {
    return _stringTemplateService.parse(REMOVE_COMMUNITY_MODERATORS_PATH,
        {'communityName': communityName, 'username': username});
  }

  String _makeGetCommunityPostsPath(String communityName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_POSTS_PATH, {'communityName': communityName});
  }

  String _makeFavoriteCommunityPath(String communityName) {
    return _stringTemplateService
        .parse(FAVORITE_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeJoinCommunityPath(String communityName) {
    return _stringTemplateService
        .parse(JOIN_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeLeaveCommunityPath(String communityName) {
    return _stringTemplateService
        .parse(LEAVE_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeUpdateCommunityPath(String communityName) {
    return _stringTemplateService
        .parse(UPDATE_COMMUNITY_PATH, {'communityName': communityName});
  }

  String _makeCommunityAvatarPath(String communityName) {
    return _stringTemplateService
        .parse(COMMUNITY_AVATAR_PATH, {'communityName': communityName});
  }

  String _makeCommunityCoverPath(String communityName) {
    return _stringTemplateService
        .parse(COMMUNITY_COVER_PATH, {'communityName': communityName});
  }

  String _makeGetCommunityMembersPath(String communityName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_MEMBERS_PATH, {'communityName': communityName});
  }

  String _makeSearchCommunityMembersPath(String communityName) {
    return _stringTemplateService
        .parse(SEARCH_COMMUNITY_MEMBERS_PATH, {'communityName': communityName});
  }

  String _makeGetCommunityBannedUsersPath(String communityName) {
    return _stringTemplateService.parse(
        GET_COMMUNITY_BANNED_USERS_PATH, {'communityName': communityName});
  }

  String _makeGetCommunityAdministratorsPath(String communityName) {
    return _stringTemplateService.parse(
        GET_COMMUNITY_ADMINISTRATORS_PATH, {'communityName': communityName});
  }

  String _makeSearchCommunityAdministratorsPath(String communityName) {
    return _stringTemplateService.parse(
        SEARCH_COMMUNITY_ADMINISTRATORS_PATH, {'communityName': communityName});
  }

  String _makeGetCommunityModeratorsPath(String communityName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_MODERATORS_PATH, {'communityName': communityName});
  }

  String _makeSearchCommunityModeratorsPath(String communityName) {
    return _stringTemplateService.parse(
        SEARCH_COMMUNITY_MODERATORS_PATH, {'communityName': communityName});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
