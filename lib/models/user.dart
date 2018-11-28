import 'package:Openbook/models/user_profile.dart';

class User {
  final int id;
  final String email;
  final String username;
  final UserProfile profile;
  final int followersCount;
  final int followingCount;
  final int postsCount;

  User(
      {this.username,
      this.id,
      this.email,
      this.profile,
      this.followersCount,
      this.followingCount,
      this.postsCount});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    var userProfile = UserProfile.fromJSON(parsedJson['profile']);

    return User(
        id: parsedJson['id'],
        followersCount: parsedJson['followers_count'],
        postsCount: parsedJson['posts_count'],
        email: parsedJson['email'],
        username: parsedJson['username'],
        followingCount: parsedJson['following_count'],
        profile: userProfile);
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
}
