import 'package:Openbook/models/user.dart';

class Connection {
  final int id;
  final User targetUser;

  Connection({this.id, this.targetUser});

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
        id: json['id'], targetUser: _parseTargetUser(json['target_user']));
  }

  static User _parseTargetUser(Map targetUserData) {
    if (targetUserData != null) return User.fromJson(targetUserData);
  }
}
