import 'package:Openbook/models/user-profile.dart';

class User {
  int id;
  String email;
  String username;
  UserProfile profile;

  User({this.username, this.id, this.email, this.profile});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    var userProfile = UserProfile.fromJSON(parsedJson['profile']);

    return User(
        id: parsedJson['id'],
        email: parsedJson['email'],
        username: parsedJson['username'],
        profile: userProfile);
  }
}
