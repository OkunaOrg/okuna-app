import 'package:Openbook/models/badge.dart';
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/circles_list.dart';
import 'package:Openbook/models/follows_lists_list.dart';
import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/user_profile.dart';
import 'package:dcache/dcache.dart';

class User extends UpdatableModel<User> {
  int id;
  int connectionsCircleId;
  String email;
  String username;
  UserProfile profile;
  int followersCount;
  int followingCount;
  int postsCount;
  bool isFollowing;
  bool isConnected;
  bool isFullyConnected;
  bool isPendingConnectionConfirmation;
  CirclesList connectedCircles;
  FollowsListsList followLists;

  static final navigationUsersFactory = UserFactory(
      cache: LfuCache<int, User>(storage: SimpleStorage(size: 100)));
  static final sessionUsersFactory = UserFactory(
      cache: SimpleCache<int, User>(storage: SimpleStorage(size: 10)));

  factory User.fromJson(Map<String, dynamic> json,
      {bool storeInSessionCache = false}) {
    int userId = json['id'];

    User user = navigationUsersFactory.getItemWithIdFromCache(userId) ??
        sessionUsersFactory.getItemWithIdFromCache(userId);

    if (user != null) {
      user.update(json);
      return user;
    }
    return storeInSessionCache
        ? sessionUsersFactory.fromJson(json)
        : navigationUsersFactory.fromJson(json);
  }

  static void clearNavigationCache() {
    navigationUsersFactory.clearCache();
  }

  static void clearSessionCache() {
    sessionUsersFactory.clearCache();
  }

  User(
      {this.id,
      this.connectionsCircleId,
      this.username,
      this.email,
      this.profile,
      this.followersCount,
      this.followingCount,
      this.postsCount,
      this.isFollowing,
      this.isConnected,
      this.isFullyConnected,
      this.connectedCircles,
      this.followLists});

  void updateFromJson(Map json) {
    if (json.containsKey('username')) username = json['username'];
    if (json.containsKey('email')) email = json['email'];
    if (json.containsKey('profile')) {
      if (profile != null) {
        profile.updateFromJson(json['profile']);
      } else {
        profile = navigationUsersFactory.parseUserProfile(json['profile']);
      }
    }
    if (json.containsKey('followers_count'))
      followersCount = json['followers_count'];
    if (json.containsKey('following_count'))
      followingCount = json['following_count'];
    if (json.containsKey('posts_count')) postsCount = json['posts_count'];
    if (json.containsKey('is_following')) isFollowing = json['is_following'];
    if (json.containsKey('is_connected')) isConnected = json['is_connected'];
    if (json.containsKey('connections_circle_id'))
      connectionsCircleId = json['connections_circle_id'];
    if (json.containsKey('is_fully_connected'))
      isFullyConnected = json['is_fully_connected'];
    if (json.containsKey('is_pending_connection_confirmation'))
      isPendingConnectionConfirmation =
          json['is_pending_connection_confirmation'];
    if (json.containsKey('connected_circles')) {
      connectedCircles =
          navigationUsersFactory.parseCircles(json['connected_circles']);
    }
    if (json.containsKey('follow_lists')) {
      followLists =
          navigationUsersFactory.parseFollowsLists(json['follow_lists']);
    }
  }

  String getEmail() {
    return this.email;
  }

  bool hasProfileLocation() {
    return profile.hasLocation();
  }

  bool hasProfileUrl() {
    return profile.hasUrl();
  }

  bool hasProfileAvatar() {
    return this.profile.avatar != null;
  }

  bool hasProfileCover() {
    return this.profile.cover != null;
  }

  String getProfileAvatar() {
    return this.profile.avatar;
  }

  String getProfileName() {
    return this.profile.name;
  }

  String getProfileCover() {
    return this.profile.cover;
  }

  String getProfileBio() {
    return this.profile.bio;
  }

  bool getProfileFollowersCountVisible() {
    return this.profile.followersCountVisible;
  }

  String getProfileUrl() {
    return this.profile.url;
  }

  String getProfileLocation() {
    return this.profile.location;
  }

  List<Badge> getProfileBadges() {
    return this.profile.badges;
  }

  bool isConnectionsCircle(Circle circle) {
    return connectionsCircleId != null && connectionsCircleId == circle.id;
  }

  bool hasFollowLists() {
    return followLists != null && followLists.lists.length > 0;
  }

  void incrementFollowersCount() {
    if (this.followersCount != null) {
      this.followersCount += 1;
      notifyUpdate();
    }
  }

  void decrementFollowersCount() {
    if (this.followersCount != null && this.followersCount > 0) {
      this.followersCount -= 1;
      notifyUpdate();
    }
  }
}

class UserFactory extends UpdatableModelFactory<User> {
  UserFactory({cache}) : super(cache: cache);

  @override
  User makeFromJson(Map json) {
    return User(
        id: json['id'],
        connectionsCircleId: json['connections_circle_id'],
        followersCount: json['followers_count'],
        postsCount: json['posts_count'],
        email: json['email'],
        username: json['username'],
        followingCount: json['following_count'],
        isFollowing: json['is_following'],
        isConnected: json['is_connected'],
        isFullyConnected: json['is_fully_connected'],
        profile: parseUserProfile(json['profile']),
        connectedCircles: parseCircles(json['connected_circles']),
        followLists: parseFollowsLists(json['follow_lists']));
  }

  UserProfile parseUserProfile(Map profile) {
    return UserProfile.fromJSON(profile);
  }

  CirclesList parseCircles(List circlesData) {
    if (circlesData == null) return null;
    return CirclesList.fromJson(circlesData);
  }

  FollowsListsList parseFollowsLists(List followsListsData) {
    if (followsListsData == null) return null;
    return FollowsListsList.fromJson(followsListsData);
  }
}
