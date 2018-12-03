import 'package:Openbook/models/follow_list.dart';
import 'package:Openbook/models/user.dart';

class Follow {
  final int id;
  final FollowList list;
  final User followedUser;

  Follow({this.id, this.list, this.followedUser});

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
        id: json['id'],
        followedUser: _parseFollowedUser(json['followed_user']));
  }

  static User _parseFollowedUser(Map followedUserData) {
    if (followedUserData != null) return User.fromJson(followedUserData);
  }
}
