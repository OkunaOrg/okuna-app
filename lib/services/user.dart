import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/models/follows_lists_list.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/connection.dart';
import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group_list.dart';
import 'package:Openbook/models/follow.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_list.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/post_reaction_list.dart';
import 'package:Openbook/models/post_reactions_emoji_count_list.dart';
import 'package:Openbook/models/posts_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/services/auth_api.dart';
import 'package:Openbook/services/connections_circles_api.dart';
import 'package:Openbook/services/connections_api.dart';
import 'package:Openbook/services/emojis_api.dart';
import 'package:Openbook/services/follows_api.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/follows_lists_api.dart';
import 'package:Openbook/services/posts_api.dart';
import 'package:Openbook/services/storage.dart';
import 'package:intl/intl.dart';
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
  EmojisApiService _emojisApiService;
  FollowsApiService _followsApiService;
  ConnectionsApiService _connectionsApiService;
  ConnectionsCirclesApiService _connectionsCirclesApiService;
  FollowsListsApiService _followsListsApiService;

  // If this is null, means user logged out.
  Stream<User> get loggedInUserChange => _loggedInUserChangeSubject.stream;

  User _loggedInUser;

  String _authToken;

  final _loggedInUserChangeSubject = ReplaySubject<User>(maxSize: 1);

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void setPostsApiService(PostsApiService postsApiService) {
    _postsApiService = postsApiService;
  }

  void setFollowsApiService(FollowsApiService followsApiService) {
    _followsApiService = followsApiService;
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

  void setEmojisApiService(EmojisApiService emojisApiService) {
    _emojisApiService = emojisApiService;
  }

  void setHttpieService(HttpieService httpieService) {
    _httpieService = httpieService;
  }

  void setStorageService(StorageService storageService) {
    _userStorage = storageService.getSecureStorage(namespace: 'user');
  }

  Future<void> logout() async {
    await _removeStoredFirstPostsData();
    await _removeStoredUserData();
    await _removeStoredAuthToken();
    _httpieService.removeAuthorizationToken();
    _removeLoggedInUser();
    Post.clearCache();
    User.clearSessionCache();
    User.clearNavigationCache();
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

  Future<void> refreshUser() async {
    if (_authToken == null) throw AuthTokenMissingError();

    try {
      HttpieResponse response =
          await _authApiService.getUserWithAuthToken(_authToken);
      _checkResponseIsOk(response);
      var userData = response.body;
      _setUserWithData(userData);
    } on HttpieConnectionRefusedError {
      // Response failed. Use stored user.
      String userData = await this._getStoredUserData();
      if (userData != null) {
        var user = _makeLoggedInUser(userData);
        _setLoggedInUser(user);
      }
      rethrow;
    }
  }

  Future<User> updateUserEmail(String email) async {
    HttpieStreamedResponse response =
        await _authApiService.updateUserEmail(email: email);

    if (response.isBadRequest()) {
      return getLoggedInUser();
    }
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

  Future<void> loginWithStoredAuthToken() async {
    var token = await _getStoredAuthToken();
    if (token == null) throw AuthTokenMissingError();

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
      bool areFirstPosts = false}) async {
    try {
      HttpieResponse response = await _postsApiService.getTimelinePosts(
          circleIds: circles.map((circle) => circle.id).toList(),
          listIds: followsLists.map((followsList) => followsList.id).toList(),
          maxId: maxId,
          count: count,
          username: username,
          authenticatedRequest: true);
      _checkResponseIsOk(response);
      String postsData = response.body;
      if (areFirstPosts) {
        this._storeFirstPostsData(postsData);
      }
      return _makePostsList(postsData);
    } on HttpieConnectionRefusedError {
      if (areFirstPosts) {
        // Response failed. Use stored first posts.
        String firstPostsData = await this._getStoredFirstPostsData();
        if (firstPostsData != null) {
          var postsList = _makePostsList(firstPostsData);
          return postsList;
        }
      }
      rethrow;
    }
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

  Future<void> deletePost(Post post) async {
    HttpieResponse response = await _postsApiService.deletePostWithId(post.id);
    _checkResponseIsOk(response);
  }

  Future<PostReaction> reactToPost(
      {@required Post post,
      @required Emoji emoji,
      @required EmojiGroup emojiGroup}) async {
    HttpieResponse response = await _postsApiService.reactToPost(
        postId: post.id, emojiId: emoji.id, emojiGroupId: emojiGroup.id);
    _checkResponseIsCreated(response);
    return PostReaction.fromJson(json.decode(response.body));
  }

  Future<void> deletePostReaction(
      {@required PostReaction postReaction, @required Post post}) async {
    HttpieResponse response = await _postsApiService.deletePostReaction(
        postReactionId: postReaction.id, postId: post.id);
    _checkResponseIsOk(response);
  }

  Future<PostReactionList> getReactionsForPost(Post post,
      {int count, int maxId, Emoji emoji}) async {
    HttpieResponse response = await _postsApiService.getReactionsForPostWithId(
        post.id,
        count: count,
        maxId: maxId,
        emojiId: emoji.id);

    _checkResponseIsOk(response);

    return PostReactionList.fromJson(json.decode(response.body));
  }

  Future<PostReactionsEmojiCountList> getReactionsEmojiCountForPost(
      Post post) async {
    HttpieResponse response =
        await _postsApiService.getReactionsEmojiCountForPostWithId(post.id);

    _checkResponseIsOk(response);

    return PostReactionsEmojiCountList.fromJson(json.decode(response.body));
  }

  Future<PostComment> commentPost(
      {@required Post post, @required String text}) async {
    HttpieResponse response =
        await _postsApiService.commentPost(postId: post.id, text: text);
    _checkResponseIsCreated(response);
    return PostComment.fromJson(json.decode(response.body));
  }

  Future<void> deletePostComment(
      {@required PostComment postComment, @required Post post}) async {
    HttpieResponse response = await _postsApiService.deletePostComment(
        postCommentId: postComment.id, postId: post.id);
    _checkResponseIsOk(response);
  }

  Future<PostCommentList> getCommentsForPost(Post post,
      {int count, int maxId}) async {
    HttpieResponse response = await _postsApiService
        .getCommentsForPostWithId(post.id, count: count, maxId: maxId);

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
    _loggedInUser = user;
    _loggedInUserChangeSubject.add(user);
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

class EmailAlreadyTakenError implements Exception {
  final String msg;

  const EmailAlreadyTakenError(this.msg);

  String toString() => 'EmailAlreadyTakenError: $msg';
}

class AuthTokenMissingError implements Exception {
  const AuthTokenMissingError();

  String toString() => 'AuthTokenMissingError: No auth token was found.';
}

class NotLoggedInUserError implements Exception {
  const NotLoggedInUserError();

  String toString() => 'NotLoggedInUserError: No user is logged in.';
}
