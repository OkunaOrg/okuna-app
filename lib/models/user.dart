import 'package:Openbook/models/user-profile.dart';

class User {
  int id;
  String email;
  String username;
  UserProfile profile;
  int followersCount;
  int postsCount;

  User(
      {this.username,
      this.id,
      this.email,
      this.profile,
      this.followersCount,
      this.postsCount});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    var userProfile = UserProfile.fromJSON(parsedJson['profile']);

    return User(
        id: parsedJson['id'],
        followersCount: parsedJson['followers_count'],
        postsCount: parsedJson['posts_count'],
        email: parsedJson['email'],
        username: parsedJson['username'],
        profile: userProfile);
  }
}
