import 'package:Openbook/models/user_profile.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dcache/dcache.dart';

class User {
  final int id;
  String email;
  String username;
  UserProfile profile;
  int followersCount;
  int followingCount;
  int postsCount;
  bool isFollowing;

  Stream<User> get updateSubject => _updateSubject.stream;
  final _updateSubject = ReplaySubject<User>(maxSize: 1);

  static final LfuCache<int, User> navigationCache =
      LfuCache(storage: SimpleStorage(size: 100));

  static final SimpleCache<int, User> sessionCache =
      SimpleCache(storage: SimpleStorage(size: 10));

  factory User.fromJson(Map<String, dynamic> json,
      {bool storeInSessionCache = false}) {
    int userId = json['id'];

    User user = navigationCache.get(userId) ?? sessionCache.get(userId);

    if (user != null) {
      user.updateFromJson(json);
      return user;
    }

    user = _makeFromJson(json);

    if (storeInSessionCache) {
      sessionCache.set(userId, user);
    } else {
      navigationCache.set(userId, user);
    }
    return user;
  }

  static void clearNavigationCache() {
    navigationCache.clear();
  }

  static void clearSessionCache() {
    sessionCache.clear();
  }

  static User _makeFromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        followersCount: json['followers_count'],
        postsCount: json['posts_count'],
        email: json['email'],
        username: json['username'],
        followingCount: json['following_count'],
        isFollowing: json['is_following'],
        profile: _parseUserProfile(json['profile']));
  }

  static UserProfile _parseUserProfile(Map profile) {
    return UserProfile.fromJSON(profile);
  }

  User(
      {this.username,
      this.id,
      this.email,
      this.profile,
      this.followersCount,
      this.followingCount,
      this.postsCount,
      this.isFollowing}) {
    _notifyUpdate();
  }

  void dispose() {
    _updateSubject.close();
  }

  void updateFromJson(Map<String, dynamic> json) {
    if (json.containsKey('username')) username = json['username'];
    if (json.containsKey('email')) email = json['email'];
    if (json.containsKey('profile')) {
      if (profile != null) {
        profile.updateFromJson(json['profile']);
      } else {
        profile = _parseUserProfile(json['profile']);
      }
    }
    if (json.containsKey('followers_count'))
      followersCount = json['followers_count'];
    if (json.containsKey('following_count'))
      followingCount = json['following_count'];
    if (json.containsKey('posts_count')) postsCount = json['posts_count'];
    if (json.containsKey('is_following')) isFollowing = json['is_following'];
    _notifyUpdate();
  }

  bool hasProfileLocation() {
    return profile.hasLocation();
  }

  bool hasProfileUrl() {
    return profile.hasUrl();
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

  DateTime getProfileBirthDate() {
    return profile.birthDate;
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

  void incrementFollowersCount() {
    if (this.followersCount != null) {
      this.followersCount += 1;
      this._notifyUpdate();
    }
  }

  void decrementFollowersCount() {
    if (this.followersCount != null) {
      this.followersCount -= 1;
      this._notifyUpdate();
    }
  }

  void _notifyUpdate() {
    _updateSubject.add(this);
  }
}
