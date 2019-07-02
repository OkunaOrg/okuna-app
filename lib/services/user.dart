import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Openbook/models/categories_list.dart';
import 'package:Openbook/models/category.dart';
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/communities_list.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/device.dart';
import 'package:Openbook/models/devices_list.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/models/follows_lists_list.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/connection.dart';
import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group_list.dart';
import 'package:Openbook/models/follow.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/language.dart';
import 'package:Openbook/models/language_list.dart';
import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/moderation/moderated_object_list.dart';
import 'package:Openbook/models/moderation/moderated_object_log_list.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/moderation/moderation_category_list.dart';
import 'package:Openbook/models/moderation/moderation_penalty_list.dart';
import 'package:Openbook/models/moderation/moderation_report_list.dart';
import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/models/notifications/notifications_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_list.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/post_reaction_list.dart';
import 'package:Openbook/models/post_reactions_emoji_count_list.dart';
import 'package:Openbook/models/posts_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/user_invite.dart';
import 'package:Openbook/models/user_invites_list.dart';
import 'package:Openbook/models/user_notifications_settings.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/auth_api.dart';
import 'package:Openbook/services/categories_api.dart';
import 'package:Openbook/services/communities_api.dart';
import 'package:Openbook/services/connections_circles_api.dart';
import 'package:Openbook/services/connections_api.dart';
import 'package:Openbook/services/devices_api.dart';
import 'package:Openbook/services/emojis_api.dart';
import 'package:Openbook/services/follows_api.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/follows_lists_api.dart';
import 'package:Openbook/services/translate_api_service.dart';
import 'package:Openbook/services/moderation_api.dart';
import 'package:Openbook/services/notifications_api.dart';
import 'package:Openbook/services/posts_api.dart';
import 'package:Openbook/services/storage.dart';
import 'package:Openbook/services/user_invites_api.dart';
import 'package:Openbook/services/waitlist_service.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
export 'package:Openbook/services/httpie.dart';

class UserService {
  OBStorage _userStorage;

  static const STORAGE_KEY_AUTH_TOKEN = 'authToken';
  static const STORAGE_KEY_USER_DATA = 'data';
  static const STORAGE_FIRST_POSTS_DATA = 'firstPostsData';

  AuthApiService _authApiService;
  HttpieService _httpieService;
  PostsApiService _postsApiService;
  ModerationApiService _moderationApiService;
  CommunitiesApiService _communitiesApiService;
  CategoriesApiService _categoriesApiService;
  EmojisApiService _emojisApiService;
  FollowsApiService _followsApiService;
  ConnectionsApiService _connectionsApiService;
  ConnectionsCirclesApiService _connectionsCirclesApiService;
  FollowsListsApiService _followsListsApiService;
  UserInvitesApiService _userInvitesApiService;
  NotificationsApiService _notificationsApiService;
  DevicesApiService _devicesApiService;
  CreateAccountBloc _createAccountBlocService;
  WaitlistApiService _waitlistApiService;
  TranslateApiService _translateApiService;

  // If this is null, means user logged out.
  Stream<User> get loggedInUserChange => _loggedInUserChangeSubject.stream;

  User _loggedInUser;

  String _authToken;

  final _loggedInUserChangeSubject = ReplaySubject<User>(maxSize: 1);

  Future<Device> _getOrCreateCurrentDeviceCache;

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void setModerationApiService(ModerationApiService moderationApiService) {
    _moderationApiService = moderationApiService;
  }

  void setPostsApiService(PostsApiService postsApiService) {
    _postsApiService = postsApiService;
  }

  void setFollowsApiService(FollowsApiService followsApiService) {
    _followsApiService = followsApiService;
  }

  void setUserInvitesApiService(UserInvitesApiService userInvitesApiService) {
    _userInvitesApiService = userInvitesApiService;
  }

  void setFollowsListsApiService(
      FollowsListsApiService followsListsApiService) {
    _followsListsApiService = followsListsApiService;
  }

  void setConnectionsApiService(ConnectionsApiService connectionsApiService) {
    _connectionsApiService = connectionsApiService;
  }

  void setConnectionsCirclesApiService(
      ConnectionsCirclesApiService circlesApiService) {
    _connectionsCirclesApiService = circlesApiService;
  }

  void setCommunitiesApiService(CommunitiesApiService communitiesApiService) {
    _communitiesApiService = communitiesApiService;
  }

  void setCategoriesApiService(CategoriesApiService categoriesApiService) {
    _categoriesApiService = categoriesApiService;
  }

  void setNotificationsApiService(
      NotificationsApiService notificationsApiService) {
    _notificationsApiService = notificationsApiService;
  }

  void setDevicesApiService(DevicesApiService devicesApiService) {
    _devicesApiService = devicesApiService;
  }

  void setEmojisApiService(EmojisApiService emojisApiService) {
    _emojisApiService = emojisApiService;
  }

  void setHttpieService(HttpieService httpieService) {
    _httpieService = httpieService;
  }

  void setStorageService(StorageService storageService) {
    _userStorage = storageService.getSecureStorage(namespace: 'user');
  }

  void setCreateAccountBlocService(CreateAccountBloc createAccountBloc) {
    _createAccountBlocService = createAccountBloc;
  }

  void setWaitlistApiService(WaitlistApiService waitlistApiService) {
    _waitlistApiService = waitlistApiService;
  }

  void setTranslateApiService(TranslateApiService translateApiService) {
    _translateApiService = translateApiService;
  }

  Future<void> deleteAccountWithPassword(String password) async {
    HttpieResponse response =
        await _authApiService.deleteUser(password: password);
    _checkResponseIsOk(response);
  }

  Future<void> logout() async {
    _deleteCurrentDevice();
    await _removeStoredUserData();
    await _removeStoredAuthToken();
    _httpieService.removeAuthorizationToken();
    _removeLoggedInUser();
    await clearCache();
    User.clearSessionCache();
    _getOrCreateCurrentDeviceCache = null;
  }

  Future<void> clearCache() async {
    await _removeStoredFirstPostsData();
    await DiskCache().clear();
    Post.clearCache();
    User.clearNavigationCache();
    PostComment.clearCache();
    Community.clearCache();
  }

  Future<void> loginWithCredentials(
      {@required String username, @required String password}) async {
    HttpieResponse response = await _authApiService.loginWithCredentials(
        username: username, password: password);
    if (response.isOk()) {
      var parsedResponse = response.parseJsonBody();
      var authToken = parsedResponse['token'];
      await loginWithAuthToken(authToken);
    } else if (response.isUnauthorized()) {
      throw CredentialsMismatchError('The provided credentials do not match.');
    } else {
      throw HttpieRequestError(response);
    }
  }

  Future<void> requestPasswordReset({String username, String email}) async {
    HttpieResponse response = await _authApiService.requestPasswordReset(
        username: username, email: email);
    _checkResponseIsOk(response);
  }

  Future<void> verifyPasswordReset(
      {@required String newPassword,
      @required String passwordResetToken}) async {
    HttpieResponse response = await _authApiService.verifyPasswordReset(
        newPassword: newPassword, passwordResetToken: passwordResetToken);
    _checkResponseIsOk(response);
  }

  Future<void> acceptGuidelines() async {
    HttpieResponse response = await _authApiService.acceptGuidelines();
    _checkResponseIsOk(response);
  }

  Future<int> subscribeToBetaWaitlist({String email}) async {
    HttpieResponse response = await _waitlistApiService.subscribeToBetaWaitlist(email: email);
    _checkResponseIsOk(response);
    Map<String, dynamic> parsedJson = json.decode(response.body);
    return parsedJson['count'];
  }

  Future<void> loginWithAuthToken(String authToken) async {
    await _setAuthToken(authToken);
    await refreshUser();
  }

  User getLoggedInUser() {
    return _loggedInUser;
  }

  bool isLoggedInUser(User user) {
    return user.id == _loggedInUser.id;
  }

  Future<User> refreshUser() async {
    if (_authToken == null) throw AuthTokenMissingError();

    HttpieResponse response =
        await _authApiService.getUserWithAuthToken(_authToken);
    _checkResponseIsOk(response);
    var userData = response.body;
    return _setUserWithData(userData);
  }

  Future<User> updateUserEmail(String email) async {
    HttpieStreamedResponse response =
        await _authApiService.updateUserEmail(email: email);
    _checkResponseIsOk(response);
    String userData = await response.readAsString();
    return _makeLoggedInUser(userData);
  }

  Future<void> updateUserPassword(
      String currentPassword, String newPassword) async {
    HttpieStreamedResponse response = await _authApiService.updateUserPassword(
        currentPassword: currentPassword, newPassword: newPassword);
    _checkResponseIsOk(response);
  }

  Future<User> updateUser({
    dynamic avatar,
    dynamic cover,
    String name,
    String username,
    String url,
    String password,
    bool followersCountVisible,
    String bio,
    String location,
  }) async {
    HttpieStreamedResponse response = await _authApiService.updateUser(
        avatar: avatar,
        cover: cover,
        name: name,
        username: username,
        url: url,
        followersCountVisible: followersCountVisible,
        bio: bio,
        location: location);

    _checkResponseIsOk(response);

    String userData = await response.readAsString();
    return _makeLoggedInUser(userData);
  }

  Future<void> loginWithStoredUserData() async {
    var token = await _getStoredAuthToken();
    if (token == null &&
        !_createAccountBlocService.hasToken() &&
        !_createAccountBlocService.hasPasswordResetToken())
      throw AuthTokenMissingError();
    if (token == null && _createAccountBlocService.hasToken()) {
      print(
          'User is in register via link flow, dont throw error as it will break the flow');
      return;
    }
    if (token == null && _createAccountBlocService.hasPasswordResetToken()) {
      print(
          'User is in reset password via link flow, dont throw error as it will break the flow');
      return;
    }

    String userData = await this._getStoredUserData();
    if (userData != null) {
      var user = _makeLoggedInUser(userData);
      _setLoggedInUser(user);
    }

    await loginWithAuthToken(token);
  }

  Future<bool> hasAuthToken() async {
    String authToken = await _getStoredAuthToken();
    return authToken != null;
  }

  bool isLoggedIn() {
    return _loggedInUser != null;
  }

  Future<PostsList> getTrendingPosts() async {
    HttpieResponse response =
        await _postsApiService.getTrendingPosts(authenticatedRequest: true);

    _checkResponseIsOk(response);

    return PostsList.fromJson(json.decode(response.body));
  }

  Future<PostsList> getTimelinePosts(
      {List<Circle> circles = const [],
      List<FollowsList> followsLists = const [],
      int maxId,
      int count,
      String username,
      bool areFirstPosts = false,
      bool cachePosts = false}) async {
    HttpieResponse response = await _postsApiService.getTimelinePosts(
        circleIds: circles.map((circle) => circle.id).toList(),
        listIds: followsLists.map((followsList) => followsList.id).toList(),
        maxId: maxId,
        count: count,
        username: username,
        authenticatedRequest: true);
    _checkResponseIsOk(response);
    String postsData = response.body;
    if (cachePosts) {
      this._storeFirstPostsData(postsData);
    }
    return _makePostsList(postsData);
  }

  Future<PostsList> getStoredFirstPosts() async {
    String firstPostsData = await this._getStoredFirstPostsData();
    if (firstPostsData != null) {
      var postsList = _makePostsList(firstPostsData);
      return postsList;
    }
    return PostsList();
  }

  Future<Post> createPost(
      {String text,
      List<Circle> circles = const [],
      File image,
      File video}) async {
    HttpieStreamedResponse response = await _postsApiService.createPost(
        text: text,
        circleIds: circles.map((circle) => circle.id).toList(),
        video: video,
        image: image);

    _checkResponseIsCreated(response);

    // Post counts have changed
    refreshUser();

    String responseBody = await response.readAsString();
    return Post.fromJson(json.decode(responseBody));
  }

  Future<Post> editPost({String postUuid, String text}) async {
    HttpieStreamedResponse response =
        await _postsApiService.editPost(postUuid: postUuid, text: text);

    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();
    return Post.fromJson(json.decode(responseBody));
  }

  Future<void> deletePost(Post post) async {
    HttpieResponse response =
        await _postsApiService.deletePostWithUuid(post.uuid);
    _checkResponseIsOk(response);
  }

  Future<Post> disableCommentsForPost(Post post) async {
    HttpieResponse response =
        await _postsApiService.disableCommentsForPostWithUuidPost(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> enableCommentsForPost(Post post) async {
    HttpieResponse response =
        await _postsApiService.enableCommentsForPostWithUuidPost(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> closePost(Post post) async {
    HttpieResponse response =
        await _postsApiService.closePostWithUuid(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> openPost(Post post) async {
    HttpieResponse response =
        await _postsApiService.openPostWithUuid(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> getPostWithUuid(String uuid) async {
    HttpieResponse response = await _postsApiService.getPostWithUuid(uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<PostReaction> reactToPost(
      {@required Post post,
      @required Emoji emoji,
      @required EmojiGroup emojiGroup}) async {
    HttpieResponse response = await _postsApiService.reactToPost(
        postUuid: post.uuid, emojiId: emoji.id, emojiGroupId: emojiGroup.id);
    _checkResponseIsCreated(response);
    return PostReaction.fromJson(json.decode(response.body));
  }

  Future<void> deletePostReaction(
      {@required PostReaction postReaction, @required Post post}) async {
    HttpieResponse response = await _postsApiService.deletePostReaction(
        postReactionId: postReaction.id, postUuid: post.uuid);
    _checkResponseIsOk(response);
  }

  Future<PostReactionList> getReactionsForPost(Post post,
      {int count, int maxId, Emoji emoji}) async {
    HttpieResponse response =
        await _postsApiService.getReactionsForPostWithUuid(post.uuid,
            count: count, maxId: maxId, emojiId: emoji.id);

    _checkResponseIsOk(response);

    return PostReactionList.fromJson(json.decode(response.body));
  }

  Future<PostReactionsEmojiCountList> getReactionsEmojiCountForPost(
      Post post) async {
    HttpieResponse response =
        await _postsApiService.getReactionsEmojiCountForPostWithUuid(post.uuid);

    _checkResponseIsOk(response);

    return PostReactionsEmojiCountList.fromJson(json.decode(response.body));
  }

  Future<PostComment> commentPost(
      {@required Post post, @required String text}) async {
    HttpieResponse response =
        await _postsApiService.commentPost(postUuid: post.uuid, text: text);
    _checkResponseIsCreated(response);
    return PostComment.fromJSON(json.decode(response.body));
  }

  Future<PostComment> editPostComment(
      {@required Post post,
      @required PostComment postComment,
      @required String text}) async {
    HttpieResponse response = await _postsApiService.editPostComment(
        postUuid: post.uuid, postCommentId: postComment.id, text: text);
    _checkResponseIsOk(response);
    return PostComment.fromJSON(json.decode(response.body));
  }

  Future<PostComment> replyPostComment(
      {@required Post post,
      @required PostComment postComment,
      @required String text}) async {
    HttpieResponse response = await _postsApiService.replyPostComment(
        postUuid: post.uuid, postCommentId: postComment.id, text: text);
    _checkResponseIsCreated(response);
    return PostComment.fromJSON(json.decode(response.body));
  }

  Future<void> deletePostComment(
      {@required PostComment postComment, @required Post post}) async {
    HttpieResponse response = await _postsApiService.deletePostComment(
        postCommentId: postComment.id, postUuid: post.uuid);
    _checkResponseIsOk(response);
  }

  Future<Post> mutePost(Post post) async {
    HttpieResponse response =
        await _postsApiService.mutePostWithUuid(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<Post> unmutePost(Post post) async {
    HttpieResponse response =
        await _postsApiService.unmutePostWithUuid(post.uuid);
    _checkResponseIsOk(response);
    return Post.fromJson(json.decode(response.body));
  }

  Future<PostCommentList> getCommentsForPost(Post post,
      {int maxId,
      int countMax,
      int minId,
      int countMin,
      PostCommentsSortType sort}) async {
    HttpieResponse response = await _postsApiService.getCommentsForPostWithUuid(
        post.uuid,
        countMax: countMax,
        maxId: maxId,
        countMin: countMin,
        minId: minId,
        sort: sort != null
            ? PostComment.convertPostCommentSortTypeToString(sort)
            : null);

    _checkResponseIsOk(response);
    return PostCommentList.fromJson(json.decode(response.body));
  }

  Future<PostCommentList> getCommentRepliesForPostComment(
      Post post, PostComment postComment,
      {int maxId,
      int countMax,
      int minId,
      int countMin,
      PostCommentsSortType sort}) async {
    HttpieResponse response = await _postsApiService
        .getRepliesForCommentWithIdForPostWithUuid(post.uuid, postComment.id,
            countMax: countMax,
            maxId: maxId,
            countMin: countMin,
            minId: minId,
            sort: sort != null
                ? PostComment.convertPostCommentSortTypeToString(sort)
                : null);

    _checkResponseIsOk(response);
    return PostCommentList.fromJson(json.decode(response.body));
  }

  Future<EmojiGroupList> getEmojiGroups() async {
    HttpieResponse response = await this._emojisApiService.getEmojiGroups();

    _checkResponseIsOk(response);

    return EmojiGroupList.fromJson(json.decode(response.body));
  }

  Future<EmojiGroupList> getReactionEmojiGroups() async {
    HttpieResponse response =
        await this._postsApiService.getReactionEmojiGroups();

    _checkResponseIsOk(response);

    return EmojiGroupList.fromJson(json.decode(response.body));
  }

  Future<LanguagesList> getAllLanguages() async {
    HttpieResponse response = await this._authApiService.getAllLanguages();

    _checkResponseIsOk(response);

    return LanguagesList.fromJson(json.decode(response.body));
  }

  Future<void> setNewLanguage(Language newLanguage) async {
    HttpieResponse response = await this._authApiService.setNewLanguage(newLanguage);

    _checkResponseIsOk(response);
  }

  Future<User> getUserWithUsername(String username) async {
    HttpieResponse response = await _authApiService
        .getUserWithUsername(username, authenticatedRequest: true);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<UsersList> getUsersWithQuery(String query) async {
    HttpieResponse response = await _authApiService.getUsersWithQuery(query,
        authenticatedRequest: true);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchLinkedUsers(
      {@required String query, int count, Community withCommunity}) async {
    HttpieResponse response = await _authApiService.searchLinkedUsers(
        query: query, count: count, withCommunity: withCommunity.name);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> getLinkedUsers(
      {bool authenticatedRequest = true,
      int maxId,
      int count,
      Community withCommunity}) async {
    HttpieResponse response = await _authApiService.getLinkedUsers(
        count: count, withCommunity: withCommunity.name, maxId: maxId);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<User> blockUser(User user) async {
    HttpieResponse response =
        await _authApiService.blockUserWithUsername(user.username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<User> unblockUser(User user) async {
    HttpieResponse response =
        await _authApiService.unblockUserWithUsername(user.username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchBlockedUsers(
      {@required String query, int count}) async {
    HttpieResponse response =
        await _authApiService.searchBlockedUsers(query: query, count: count);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> getBlockedUsers({int maxId, int count}) async {
    HttpieResponse response =
        await _authApiService.getBlockedUsers(count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchFollowers({@required String query, int count}) async {
    HttpieResponse response =
        await _authApiService.searchFollowers(query: query, count: count);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> getFollowers(
      {bool authenticatedRequest = true,
      int maxId,
      int count,
      Community withCommunity}) async {
    HttpieResponse response =
        await _authApiService.getFollowers(count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchFollowings(
      {@required String query, int count, Community withCommunity}) async {
    HttpieResponse response =
        await _authApiService.searchFollowings(query: query, count: count);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> getFollowings(
      {bool authenticatedRequest = true,
      int maxId,
      int count,
      Community withCommunity}) async {
    HttpieResponse response =
        await _authApiService.getFollowings(count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return UsersList.fromJson(json.decode(response.body));
  }

  Future<Follow> followUserWithUsername(String username,
      {List<FollowsList> followsLists = const []}) async {
    HttpieResponse response = await _followsApiService.followUserWithUsername(
        username,
        listsIds: followsLists.map((followsList) => followsList.id).toList());
    _checkResponseIsCreated(response);
    return Follow.fromJson(json.decode(response.body));
  }

  Future<User> unFollowUserWithUsername(String username) async {
    HttpieResponse response =
        await _followsApiService.unFollowUserWithUsername(username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<Follow> updateFollowWithUsername(String username,
      {List<FollowsList> followsLists = const []}) async {
    HttpieResponse response = await _followsApiService.updateFollowWithUsername(
        username,
        listsIds: followsLists.map((followsList) => followsList.id).toList());
    _checkResponseIsOk(response);
    return Follow.fromJson(json.decode(response.body));
  }

  Future<Connection> connectWithUserWithUsername(String username,
      {List<Circle> circles = const []}) async {
    HttpieResponse response =
        await _connectionsApiService.connectWithUserWithUsername(username,
            circlesIds: circles.map((circle) => circle.id).toList());
    _checkResponseIsCreated(response);
    return Connection.fromJson(json.decode(response.body));
  }

  Future<Connection> confirmConnectionWithUserWithUsername(String username,
      {List<Circle> circles = const []}) async {
    HttpieResponse response = await _connectionsApiService
        .confirmConnectionWithUserWithUsername(username,
            circlesIds: circles.map((circle) => circle.id).toList());
    _checkResponseIsOk(response);
    return Connection.fromJson(json.decode(response.body));
  }

  Future<User> disconnectFromUserWithUsername(String username) async {
    HttpieResponse response =
        await _connectionsApiService.disconnectFromUserWithUsername(username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<Connection> updateConnectionWithUsername(String username,
      {List<Circle> circles = const []}) async {
    HttpieResponse response =
        await _connectionsApiService.updateConnectionWithUsername(username,
            circlesIds: circles.map((circle) => circle.id).toList());
    _checkResponseIsOk(response);
    return Connection.fromJson(json.decode(response.body));
  }

  Future<Circle> getConnectionsCircleWithId(int circleId) async {
    HttpieResponse response =
        await _connectionsCirclesApiService.getCircleWithId(circleId);
    _checkResponseIsOk(response);
    return Circle.fromJSON(json.decode(response.body));
  }

  Future<CirclesList> getConnectionsCircles() async {
    HttpieResponse response = await _connectionsCirclesApiService.getCircles();
    _checkResponseIsOk(response);
    return CirclesList.fromJson(json.decode(response.body));
  }

  Future<Circle> createConnectionsCircle(
      {@required String name, String color}) async {
    HttpieResponse response = await _connectionsCirclesApiService.createCircle(
        name: name, color: color);
    _checkResponseIsCreated(response);
    return Circle.fromJSON(json.decode(response.body));
  }

  Future<Circle> updateConnectionsCircle(Circle circle,
      {String name, String color, List<User> users = const []}) async {
    HttpieResponse response =
        await _connectionsCirclesApiService.updateCircleWithId(circle.id,
            name: name,
            color: color,
            usernames: users.map((user) => user.username).toList());
    _checkResponseIsOk(response);
    return Circle.fromJSON(json.decode(response.body));
  }

  Future<void> deleteConnectionsCircle(Circle circle) async {
    HttpieResponse response =
        await _connectionsCirclesApiService.deleteCircleWithId(circle.id);
    _checkResponseIsOk(response);
  }

  Future<FollowsListsList> getFollowsLists() async {
    HttpieResponse response = await _followsListsApiService.getLists();
    _checkResponseIsOk(response);
    return FollowsListsList.fromJson(json.decode(response.body));
  }

  Future<FollowsList> createFollowsList(
      {@required String name, Emoji emoji}) async {
    HttpieResponse response =
        await _followsListsApiService.createList(name: name, emojiId: emoji.id);
    _checkResponseIsCreated(response);
    return FollowsList.fromJSON(json.decode(response.body));
  }

  Future<FollowsList> updateFollowsList(FollowsList list,
      {String name, Emoji emoji, List<User> users}) async {
    HttpieResponse response = await _followsListsApiService.updateListWithId(
        list.id,
        name: name,
        emojiId: emoji.id,
        usernames: users.map((user) => user.username).toList());
    _checkResponseIsOk(response);
    return FollowsList.fromJSON(json.decode(response.body));
  }

  Future<void> deleteFollowsList(FollowsList list) async {
    HttpieResponse response =
        await _followsListsApiService.deleteListWithId(list.id);
    _checkResponseIsOk(response);
  }

  Future<FollowsList> getFollowsListWithId(int listId) async {
    HttpieResponse response =
        await _followsListsApiService.getListWithId(listId);
    _checkResponseIsOk(response);
    return FollowsList.fromJSON(json.decode(response.body));
  }

  Future<UserInvite> createUserInvite({String nickname}) async {
    HttpieStreamedResponse response =
        await _userInvitesApiService.createUserInvite(nickname: nickname);
    _checkResponseIsCreated(response);

    String responseBody = await response.readAsString();
    return UserInvite.fromJSON(json.decode(responseBody));
  }

  Future<UserInvite> updateUserInvite(
      {String nickname, UserInvite userInvite}) async {
    HttpieStreamedResponse response = await _userInvitesApiService
        .updateUserInvite(nickname: nickname, userInviteId: userInvite.id);
    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();
    return UserInvite.fromJSON(json.decode(responseBody));
  }

  Future<UserInvitesList> getUserInvites(
      {int offset, int count, UserInviteFilterByStatus status}) async {
    bool isPending = status != null
        ? UserInvite.convertUserInviteStatusToBool(status)
        : UserInvite.convertUserInviteStatusToBool(
            UserInviteFilterByStatus.all);

    HttpieResponse response = await _userInvitesApiService.getUserInvites(
        isStatusPending: isPending, count: count, offset: offset);
    _checkResponseIsOk(response);
    return UserInvitesList.fromJson(json.decode(response.body));
  }

  Future<UserInvitesList> searchUserInvites(
      {int count, UserInviteFilterByStatus status, String query}) async {
    bool isPending = status != null
        ? UserInvite.convertUserInviteStatusToBool(status)
        : UserInvite.convertUserInviteStatusToBool(
            UserInviteFilterByStatus.all);

    HttpieResponse response = await _userInvitesApiService.searchUserInvites(
        isStatusPending: isPending, count: count, query: query);
    _checkResponseIsOk(response);
    return UserInvitesList.fromJson(json.decode(response.body));
  }

  Future<void> deleteUserInvite(UserInvite userInvite) async {
    HttpieResponse response =
        await _userInvitesApiService.deleteUserInvite(userInvite.id);
    _checkResponseIsOk(response);
  }

  Future<void> sendUserInviteEmail(UserInvite userInvite, String email) async {
    HttpieResponse response = await _userInvitesApiService.emailUserInvite(
        userInviteId: userInvite.id, email: email);

    _checkResponseIsOk(response);
  }

  Future<CommunitiesList> getTrendingCommunities({Category category}) async {
    HttpieResponse response = await _communitiesApiService
        .getTrendingCommunities(category: category?.name);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<Post> createPostForCommunity(Community community,
      {String text, File image, File video}) async {
    HttpieStreamedResponse response = await _communitiesApiService
        .createPostForCommunityWithId(community.name,
            text: text, image: image, video: video);
    _checkResponseIsCreated(response);

    String responseBody = await response.readAsString();

    return Post.fromJson(json.decode(responseBody));
  }

  Future<PostsList> getPostsForCommunity(Community community,
      {int maxId, int count}) async {
    HttpieResponse response = await _communitiesApiService
        .getPostsForCommunityWithName(community.name,
            count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return PostsList.fromJson(json.decode(response.body));
  }

  Future<PostsList> getClosedPostsForCommunity(Community community,
      {int maxId, int count}) async {
    HttpieResponse response = await _communitiesApiService
        .getClosedPostsForCommunityWithName(community.name,
            count: count, maxId: maxId);
    _checkResponseIsOk(response);
    return PostsList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> getCommunitiesWithQuery(String query) async {
    HttpieResponse response =
        await _communitiesApiService.getCommunitiesWithQuery(query: query);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<Community> createCommunity(
      {@required String name,
      @required String title,
      @required List<Category> categories,
      @required CommunityType type,
      String color,
      String userAdjective,
      String usersAdjective,
      bool invitesEnabled,
      String description,
      String rules,
      File cover,
      File avatar}) async {
    HttpieStreamedResponse response =
        await _communitiesApiService.createCommunity(
            name: name,
            title: title,
            categories: categories.map((category) => category.name).toList(),
            type: Community.convertTypeToString(type),
            color: color,
            userAdjective: userAdjective,
            usersAdjective: usersAdjective,
            invitesEnabled: invitesEnabled,
            description: description,
            rules: rules,
            cover: cover,
            avatar: avatar);

    _checkResponseIsCreated(response);

    String responseBody = await response.readAsString();

    return Community.fromJSON(json.decode(responseBody));
  }

  Future<Community> updateCommunity(Community community,
      {String name,
      String title,
      List<Category> categories,
      CommunityType type,
      String color,
      String userAdjective,
      String usersAdjective,
      String description,
      bool invitesEnabled,
      String rules,
      File cover,
      File avatar}) async {
    HttpieStreamedResponse response =
        await _communitiesApiService.updateCommunityWithName(
      community.name,
      name: name,
      title: title,
      categories: categories.map((category) => category.name).toList(),
      type: Community.convertTypeToString(type),
      color: color,
      invitesEnabled: invitesEnabled,
      userAdjective: userAdjective,
      usersAdjective: usersAdjective,
      description: description,
      rules: rules,
    );

    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();

    return Community.fromJSON(json.decode(responseBody));
  }

  Future<Community> updateAvatarForCommunity(Community community,
      {@required File avatar}) async {
    HttpieStreamedResponse response = await _communitiesApiService
        .updateAvatarForCommunityWithName(community.name, avatar: avatar);

    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();

    return Community.fromJSON(json.decode(responseBody));
  }

  Future<Community> deleteAvatarForCommunity(Community community) async {
    HttpieResponse response = await _communitiesApiService
        .deleteAvatarForCommunityWithName(community.name);

    _checkResponseIsOk(response);

    String responseBody = response.body;

    return Community.fromJSON(json.decode(responseBody));
  }

  Future<Community> updateCoverForCommunity(Community community,
      {@required File cover}) async {
    HttpieStreamedResponse response = await _communitiesApiService
        .updateCoverForCommunityWithName(community.name, cover: cover);

    _checkResponseIsOk(response);

    String responseBody = await response.readAsString();

    return Community.fromJSON(json.decode(responseBody));
  }

  Future<Community> deleteCoverForCommunity(Community community) async {
    HttpieResponse response = await _communitiesApiService
        .deleteCoverForCommunityWithName(community.name);

    _checkResponseIsOk(response);

    String responseBody = response.body;

    return Community.fromJSON(json.decode(responseBody));
  }

  Future<Community> getCommunityWithName(String name) async {
    HttpieResponse response =
        await _communitiesApiService.getCommunityWithName(name);
    _checkResponseIsOk(response);
    return Community.fromJSON(json.decode(response.body));
  }

  Future<void> deleteCommunity(Community community) async {
    HttpieResponse response =
        await _communitiesApiService.deleteCommunityWithName(community.name);
    _checkResponseIsOk(response);
  }

  Future<UsersList> getMembersForCommunity(Community community,
      {int count, int maxId, List<CommunityMembersExclusion> exclude}) async {
    HttpieResponse response = await _communitiesApiService
        .getMembersForCommunityWithId(community.name,
            count: count,
            maxId: maxId,
            exclude: exclude != null
                ? exclude
                    .map((exclude) =>
                        Community.convertExclusionToString(exclude))
                    .toList()
                : null);

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchCommunityMembers(
      {@required Community community,
      @required String query,
      List<CommunityMembersExclusion> exclude}) async {
    HttpieResponse response = await _communitiesApiService.searchMembers(
      communityName: community.name,
      query: query,
      exclude: exclude != null
          ? exclude
              .map((exclude) => Community.convertExclusionToString(exclude))
              .toList()
          : null,
    );

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<void> inviteUserToCommunity(
      {@required Community community, @required User user}) async {
    HttpieResponse response =
        await _communitiesApiService.inviteUserToCommunity(
            communityName: community.name, username: user.username);
    _checkResponseIsCreated(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<void> uninviteUserFromCommunity(
      {@required Community community, @required User user}) async {
    HttpieResponse response =
        await _communitiesApiService.uninviteUserFromCommunity(
            communityName: community.name, username: user.username);
    _checkResponseIsOk(response);
    return User.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> getJoinedCommunities({int offset}) async {
    HttpieResponse response =
        await _communitiesApiService.getJoinedCommunities(offset: offset);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> searchJoinedCommunities(
      {@required String query, int count, Community withCommunity}) async {
    HttpieResponse response = await _communitiesApiService
        .searchJoinedCommunities(query: query, count: count);
    _checkResponseIsOk(response);
    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<Community> joinCommunity(Community community) async {
    HttpieResponse response =
        await _communitiesApiService.joinCommunityWithId(community.name);
    _checkResponseIsCreated(response);
    return Community.fromJSON(json.decode(response.body));
  }

  Future<Community> leaveCommunity(Community community) async {
    HttpieResponse response =
        await _communitiesApiService.leaveCommunityWithId(community.name);
    _checkResponseIsOk(response);
    return Community.fromJSON(json.decode(response.body));
  }

  Future<UsersList> getModeratorsForCommunity(Community community,
      {int count, int maxId}) async {
    HttpieResponse response = await _communitiesApiService
        .getModeratorsForCommunityWithId(community.name,
            count: count, maxId: maxId);

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchCommunityModerators({
    @required Community community,
    @required String query,
  }) async {
    HttpieResponse response = await _communitiesApiService.searchModerators(
      communityName: community.name,
      query: query,
    );

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<void> addCommunityModerator(
      {@required Community community, @required User user}) async {
    HttpieResponse response =
        await _communitiesApiService.addCommunityModerator(
            communityName: community.name, username: user.username);
    _checkResponseIsCreated(response);
  }

  Future<void> removeCommunityModerator(
      {@required Community community, @required User user}) async {
    HttpieResponse response =
        await _communitiesApiService.removeCommunityModerator(
            communityName: community.name, username: user.username);
    _checkResponseIsOk(response);
  }

  Future<UsersList> getAdministratorsForCommunity(Community community,
      {int count, int maxId}) async {
    HttpieResponse response = await _communitiesApiService
        .getAdministratorsForCommunityWithName(community.name,
            count: count, maxId: maxId);

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchCommunityAdministrators({
    @required Community community,
    @required String query,
  }) async {
    HttpieResponse response = await _communitiesApiService.searchAdministrators(
      communityName: community.name,
      query: query,
    );

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<Community> addCommunityAdministrator(
      {@required Community community, @required User user}) async {
    HttpieResponse response =
        await _communitiesApiService.addCommunityAdministrator(
            communityName: community.name, username: user.username);
    _checkResponseIsCreated(response);
    return Community.fromJSON(json.decode(response.body));
  }

  Future<void> removeCommunityAdministrator(
      {@required Community community, @required User user}) async {
    HttpieResponse response =
        await _communitiesApiService.removeCommunityAdministrator(
            communityName: community.name, username: user.username);
    _checkResponseIsOk(response);
  }

  Future<UsersList> getBannedUsersForCommunity(Community community,
      {int count, int maxId}) async {
    HttpieResponse response = await _communitiesApiService
        .getBannedUsersForCommunityWithId(community.name,
            count: count, maxId: maxId);

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<UsersList> searchCommunityBannedUsers({
    @required Community community,
    @required String query,
  }) async {
    HttpieResponse response = await _communitiesApiService.searchBannedUsers(
      communityName: community.name,
      query: query,
    );

    _checkResponseIsOk(response);

    return UsersList.fromJson(json.decode(response.body));
  }

  Future<void> banCommunityUser(
      {@required Community community, @required User user}) async {
    HttpieResponse response = await _communitiesApiService.banCommunityUser(
        communityName: community.name, username: user.username);
    _checkResponseIsOk(response);
  }

  Future<void> unbanCommunityUser(
      {@required Community community, @required User user}) async {
    HttpieResponse response = await _communitiesApiService.unbanCommunityUser(
        communityName: community.name, username: user.username);
    _checkResponseIsOk(response);
  }

  Future<CommunitiesList> getFavoriteCommunities({int offset}) async {
    HttpieResponse response =
        await _communitiesApiService.getFavoriteCommunities(offset: offset);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<void> favoriteCommunity(Community community) async {
    HttpieResponse response = await _communitiesApiService.favoriteCommunity(
        communityName: community.name);
    _checkResponseIsCreated(response);
    return Community.fromJSON(json.decode(response.body));
  }

  Future<void> unfavoriteCommunity(Community community) async {
    HttpieResponse response = await _communitiesApiService.unfavoriteCommunity(
        communityName: community.name);
    _checkResponseIsOk(response);
    return Community.fromJSON(json.decode(response.body));
  }

  Future<CommunitiesList> getAdministratedCommunities({int offset}) async {
    HttpieResponse response = await _communitiesApiService
        .getAdministratedCommunities(offset: offset);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> getModeratedCommunities({int offset}) async {
    HttpieResponse response =
        await _communitiesApiService.getModeratedCommunities(offset: offset);

    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<CategoriesList> getCategories() async {
    HttpieResponse response = await _categoriesApiService.getCategories();
    _checkResponseIsOk(response);
    return CategoriesList.fromJson(json.decode(response.body));
  }

  Future<NotificationsList> getNotifications({int maxId, int count}) async {
    HttpieResponse response = await _notificationsApiService.getNotifications(
        maxId: maxId, count: count);
    _checkResponseIsOk(response);
    return NotificationsList.fromJson(json.decode(response.body));
  }

  Future<OBNotification> getNotificationWithId(int notificationId) async {
    HttpieResponse response =
        await _notificationsApiService.getNotificationWithId(notificationId);
    _checkResponseIsOk(response);
    return OBNotification.fromJSON(json.decode(response.body));
  }

  Future<void> readNotifications({int maxId}) async {
    HttpieResponse response =
        await _notificationsApiService.readNotifications(maxId: maxId);
    _checkResponseIsOk(response);
  }

  Future<void> deleteNotifications() async {
    HttpieResponse response =
        await _notificationsApiService.deleteNotifications();
    _checkResponseIsOk(response);
  }

  Future<void> deleteNotification(OBNotification notification) async {
    HttpieResponse response = await _notificationsApiService
        .deleteNotificationWithId(notification.id);
    _checkResponseIsOk(response);
  }

  Future<void> readNotification(OBNotification notification) async {
    HttpieResponse response =
        await _notificationsApiService.readNotificationWithId(notification.id);
    _checkResponseIsOk(response);
  }

  Future<DevicesList> getDevices() async {
    HttpieResponse response = await _devicesApiService.getDevices();
    _checkResponseIsOk(response);
    return DevicesList.fromJson(json.decode(response.body));
  }

  Future<void> deleteDevices() async {
    HttpieResponse response = await _devicesApiService.deleteDevices();
    _checkResponseIsOk(response);
  }

  Future<Device> createDevice({@required String uuid, String name}) async {
    HttpieResponse response =
        await _devicesApiService.createDevice(uuid: uuid, name: name);
    _checkResponseIsCreated(response);
    return Device.fromJSON(json.decode(response.body));
  }

  Future<Device> updateDevice(Device device, {String name}) async {
    HttpieResponse response = await _devicesApiService.updateDeviceWithUuid(
      device.uuid,
      name: name,
    );
    _checkResponseIsCreated(response);
    return Device.fromJSON(json.decode(response.body));
  }

  Future<void> deleteDevice(Device device) async {
    HttpieResponse response =
        await _devicesApiService.deleteDeviceWithUuid(device.uuid);
    _checkResponseIsOk(response);
  }

  Future<Device> getDeviceWithUuid(String deviceUuid) async {
    HttpieResponse response =
        await _devicesApiService.getDeviceWithUuid(deviceUuid);
    _checkResponseIsOk(response);
    return Device.fromJSON(json.decode(response.body));
  }

  Future<Device> getOrCreateCurrentDevice() async {
    if (_getOrCreateCurrentDeviceCache != null)
      return _getOrCreateCurrentDeviceCache;

    _getOrCreateCurrentDeviceCache = _getOrCreateCurrentDevice();
    _getOrCreateCurrentDeviceCache.catchError((error) {
      _getOrCreateCurrentDeviceCache = null;
      throw error;
    });

    return _getOrCreateCurrentDeviceCache;
  }

  Future<Device> _getOrCreateCurrentDevice() async {
    if (_getOrCreateCurrentDeviceCache != null)
      return _getOrCreateCurrentDeviceCache;

    String deviceUuid = await _getDeviceUuid();
    HttpieResponse response =
        await _devicesApiService.getDeviceWithUuid(deviceUuid);

    if (response.isNotFound()) {
      // Device does not exists, create one.
      String deviceName = await _getDeviceName();
      return createDevice(uuid: deviceUuid, name: deviceName);
    } else if (response.isOk()) {
      // Device exists
      return Device.fromJSON(json.decode(response.body));
    } else {
      throw HttpieRequestError(response);
    }
  }

  Future<void> _deleteCurrentDevice() async {
    if (_getOrCreateCurrentDeviceCache == null) return;

    Device currentDevice = await _getOrCreateCurrentDeviceCache;

    HttpieResponse response =
        await _devicesApiService.deleteDeviceWithUuid(currentDevice.uuid);

    if (!response.isOk() && !response.isNotFound()) {
      print('Could not delete current device');
    } else {
      print('Deleted current device successfully');
    }
  }

  Future<UserNotificationsSettings>
      getAuthenticatedUserNotificationsSettings() async {
    HttpieResponse response =
        await _authApiService.getAuthenticatedUserNotificationsSettings();
    _checkResponseIsOk(response);
    return UserNotificationsSettings.fromJSON(json.decode(response.body));
  }

  Future<UserNotificationsSettings>
      updateAuthenticatedUserNotificationsSettings({
    bool postCommentNotifications,
    bool postReactionNotifications,
    bool followNotifications,
    bool connectionRequestNotifications,
    bool connectionConfirmedNotifications,
    bool communityInviteNotifications,
  }) async {
    HttpieResponse response =
        await _authApiService.updateAuthenticatedUserNotificationsSettings(
            postCommentNotifications: postCommentNotifications,
            postReactionNotifications: postReactionNotifications,
            followNotifications: followNotifications,
            connectionConfirmedNotifications: connectionConfirmedNotifications,
            communityInviteNotifications: communityInviteNotifications,
            connectionRequestNotifications: connectionRequestNotifications);
    _checkResponseIsOk(response);
    return UserNotificationsSettings.fromJSON(json.decode(response.body));
  }

  Future<void> reportUser(
      {@required User user,
      String description,
      @required ModerationCategory moderationCategory}) async {
    HttpieResponse response = await _authApiService.reportUserWithUsername(
        description: description,
        userUsername: user.username,
        moderationCategoryId: moderationCategory.id);
    _checkResponseIsCreated(response);
  }

  Future<void> reportCommunity(
      {@required Community community,
      String description,
      @required ModerationCategory moderationCategory}) async {
    HttpieResponse response = await _communitiesApiService.reportCommunity(
        communityName: community.name,
        description: description,
        moderationCategoryId: moderationCategory.id);
    _checkResponseIsCreated(response);
  }

  Future<void> reportPost(
      {@required Post post,
      String description,
      @required ModerationCategory moderationCategory}) async {
    HttpieResponse response = await _postsApiService.reportPost(
        description: description,
        postUuid: post.uuid,
        moderationCategoryId: moderationCategory.id);
    _checkResponseIsCreated(response);
  }

  Future<void> reportPostComment(
      {@required PostComment postComment,
      @required Post post,
      String description,
      @required ModerationCategory moderationCategory}) async {
    HttpieResponse response = await _postsApiService.reportPostComment(
        postCommentId: postComment.id,
        postUuid: post.uuid,
        description: description,
        moderationCategoryId: moderationCategory.id);
    _checkResponseIsCreated(response);
  }

  Future<ModeratedObjectsList> getGlobalModeratedObjects(
      {List<ModeratedObjectStatus> statuses,
      List<ModeratedObjectType> types,
      int count,
      int maxId,
      bool verified}) async {
    HttpieResponse response =
        await _moderationApiService
            .getGlobalModeratedObjects(
                maxId: maxId,
                verified: verified,
                types: types != null
                    ? types
                        .map((ModeratedObjectType type) =>
                            ModeratedObject.factory.convertTypeToString(type))
                        .toList()
                    : null,
                statuses:
                    statuses != null
                        ? statuses
                            .map(
                                (ModeratedObjectStatus status) =>
                                    ModeratedObject.factory
                                        .convertStatusToString(status))
                            .toList()
                        : null,
                count: count);

    _checkResponseIsOk(response);

    return ModeratedObjectsList.fromJson(json.decode(response.body));
  }

  Future<ModeratedObjectsList> getCommunityModeratedObjects(
      {@required Community community,
      List<ModeratedObjectStatus> statuses,
      List<ModeratedObjectType> types,
      int count,
      int maxId,
      bool verified}) async {
    HttpieResponse response = await _communitiesApiService.getModeratedObjects(
        communityName: community.name,
        maxId: maxId,
        verified: verified,
        types: types != null
            ? types
                .map((status) =>
                    ModeratedObject.factory.convertTypeToString(status))
                .toList()
            : null,
        statuses: statuses != null
            ? statuses
                .map((status) =>
                    ModeratedObject.factory.convertStatusToString(status))
                .toList()
            : null,
        count: count);

    _checkResponseIsOk(response);

    return ModeratedObjectsList.fromJson(json.decode(response.body));
  }

  Future<void> updateModeratedObject(ModeratedObject moderatedObject,
      {String description, ModerationCategory category}) async {
    HttpieResponse response = await _moderationApiService
        .updateModeratedObjectWithId(moderatedObject.id,
            description: description, categoryId: category?.id);
    _checkResponseIsOk(response);
    return ModeratedObject.fromJSON(json.decode(response.body));
  }

  Future<void> verifyModeratedObject(ModeratedObject moderatedObject) async {
    HttpieResponse response = await _moderationApiService
        .verifyModeratedObjectWithId(moderatedObject.id);
    _checkResponseIsOk(response);
  }

  Future<ModeratedObjectLogsList> getModeratedObjectLogs(
      ModeratedObject moderatedObject,
      {int maxId,
      int count}) async {
    HttpieResponse response = await _moderationApiService
        .getModeratedObjectLogs(moderatedObject.id, maxId: maxId, count: count);
    _checkResponseIsOk(response);

    return ModeratedObjectLogsList.fromJson(json.decode(response.body));
  }

  Future<ModerationReportsList> getModeratedObjectReports(
      ModeratedObject moderatedObject,
      {int maxId,
      int count}) async {
    HttpieResponse response = await _moderationApiService
        .getModeratedObjectReports(moderatedObject.id,
            maxId: maxId, count: count);
    _checkResponseIsOk(response);

    return ModerationReportsList.fromJson(json.decode(response.body));
  }

  Future<ModerationPenaltiesList> getModerationPenalties(
      {int maxId, int count}) async {
    HttpieResponse response = await _moderationApiService
        .getUserModerationPenalties(maxId: maxId, count: count);
    _checkResponseIsOk(response);

    return ModerationPenaltiesList.fromJson(json.decode(response.body));
  }

  Future<CommunitiesList> getPendingModeratedObjectsCommunities(
      {int maxId, int count}) async {
    HttpieResponse response = await _moderationApiService
        .getUserPendingModeratedObjectsCommunities(maxId: maxId, count: count);
    _checkResponseIsOk(response);

    return CommunitiesList.fromJson(json.decode(response.body));
  }

  Future<void> unverifyModeratedObject(ModeratedObject moderatedObject) async {
    HttpieResponse response = await _moderationApiService
        .unverifyModeratedObjectWithId(moderatedObject.id);
    _checkResponseIsOk(response);
  }

  Future<void> approveModeratedObject(ModeratedObject moderatedObject) async {
    HttpieResponse response = await _moderationApiService
        .approveModeratedObjectWithId(moderatedObject.id);
    _checkResponseIsOk(response);
  }

  Future<void> rejectModeratedObject(ModeratedObject moderatedObject) async {
    HttpieResponse response = await _moderationApiService
        .rejectModeratedObjectWithId(moderatedObject.id);
    _checkResponseIsOk(response);
  }

  Future<ModerationCategoriesList> getModerationCategories() async {
    HttpieResponse response =
        await _moderationApiService.getModerationCategories();

    _checkResponseIsOk(response);

    return ModerationCategoriesList.fromJson(json.decode(response.body));
  }

  Future<String> _getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String deviceName;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceName = iosDeviceInfo.utsname.machine;
    } else {
      deviceName = 'Unknown';
    }

    return deviceName;
  }

  Future<String> _getDeviceUuid() async {
    String identifier;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var build = await deviceInfo.androidInfo;
      identifier = build.androidId;
    } else if (Platform.isIOS) {
      var data = await deviceInfo.iosInfo;
      identifier = data.identifierForVendor;
    } else {
      throw 'Unsupported platform';
    }

    var bytes = utf8.encode(identifier);
    var digest = sha256.convert(bytes);

    return digest.toString();
  }

  Future<User> _setUserWithData(String userData) async {
    var user = _makeLoggedInUser(userData);
    _setLoggedInUser(user);
    await _storeUserData(userData);
    return user;
  }

  void _checkResponseIsCreated(HttpieBaseResponse response) {
    if (response.isCreated()) return;
    throw HttpieRequestError(response);
  }

  void _checkResponseIsOk(HttpieBaseResponse response) {
    if (response.isOk()) return;
    throw HttpieRequestError(response);
  }

  void _setLoggedInUser(User user) {
    if (_loggedInUser == null || _loggedInUser.id != user.id)
      _loggedInUserChangeSubject.add(user);
    _loggedInUser = user;
  }

  void _removeLoggedInUser() {
    _loggedInUser = null;
    _loggedInUserChangeSubject.add(null);
  }

  Future<void> _setAuthToken(String authToken) async {
    _authToken = authToken;
    _httpieService.setAuthorizationToken(authToken);
    await _storeAuthToken(authToken);
  }

  Future<void> _storeAuthToken(String authToken) {
    return _userStorage.set(STORAGE_KEY_AUTH_TOKEN, authToken);
  }

  Future<String> _getStoredAuthToken() async {
    String authToken = await _userStorage.get(STORAGE_KEY_AUTH_TOKEN);
    if (authToken != null) _authToken = authToken;
    return authToken;
  }

  Future<void> _removeStoredAuthToken() async {
    _userStorage.remove(STORAGE_KEY_AUTH_TOKEN);
  }

  Future<void> _storeUserData(String userData) {
    return _userStorage.set(STORAGE_KEY_USER_DATA, userData);
  }

  Future<void> _removeStoredUserData() async {
    _userStorage.remove(STORAGE_KEY_USER_DATA);
  }

  Future<String> _getStoredUserData() async {
    return _userStorage.get(STORAGE_KEY_USER_DATA);
  }

  Future<void> _storeFirstPostsData(String firstPostsData) {
    return _userStorage.set(STORAGE_FIRST_POSTS_DATA, firstPostsData);
  }

  Future<void> _removeStoredFirstPostsData() async {
    _userStorage.remove(STORAGE_FIRST_POSTS_DATA);
  }

  Future<String> _getStoredFirstPostsData() async {
    return _userStorage.get(STORAGE_FIRST_POSTS_DATA);
  }

  User _makeLoggedInUser(String userData) {
    return User.fromJson(json.decode(userData), storeInSessionCache: true);
  }

  PostsList _makePostsList(String postsData) {
    return PostsList.fromJson(json.decode(postsData));
  }
}

class CredentialsMismatchError implements Exception {
  final String msg;

  const CredentialsMismatchError(this.msg);

  String toString() => 'CredentialsMismatchError: $msg';
}

class AuthTokenMissingError implements Exception {
  const AuthTokenMissingError();

  String toString() => 'AuthTokenMissingError: No auth token was found.';
}

class NotLoggedInUserError implements Exception {
  const NotLoggedInUserError();

  String toString() => 'NotLoggedInUserError: No user is logged in.';
}
