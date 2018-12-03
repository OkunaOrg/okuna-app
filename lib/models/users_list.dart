import 'package:Openbook/models/user.dart';

class UsersList {
  final List<User> users;

  UsersList({
    this.users,
  });

  factory UsersList.fromJson(List<dynamic> parsedJson) {
    List<User> users =
        parsedJson.map((userJson) => User.fromJson(userJson)).toList();

    return new UsersList(
      users: users,
    );
  }
}
