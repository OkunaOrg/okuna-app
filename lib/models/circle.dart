import 'package:Openbook/models/updatable_model.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:dcache/dcache.dart';

class Circle extends UpdatableModel<Circle> {
  final int id;
  final User creator;
  String name;
  String color;
  int usersCount;
  UsersList users;

  Circle({
    this.id,
    this.creator,
    this.name,
    this.color,
    this.usersCount,
    this.users,
  });

  static final factory = CircleFactory();

  factory Circle.fromJSON(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('users')) {
      users = factory.parseUsers(json['users']);
    }
    if (json.containsKey('name')) {
      name = json['name'];
    }
    if (json.containsKey('users_count')) {
      usersCount = json['users_count'];
    }
    if (json.containsKey('color')) {
      color = json['color'];
    }
  }

  bool hasUsers() {
    return users != null && users.users.length > 0;
  }
}

class CircleFactory extends UpdatableModelFactory<Circle> {
  @override
  SimpleCache<int, Circle> cache =
      SimpleCache(storage: SimpleStorage(size: 20));

  @override
  Circle makeFromJson(Map json) {
    return Circle(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      usersCount: json['users_count'],
      creator: parseUser(json['creator']),
      users: parseUsers(json['users']),
    );
  }

  User parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }

  UsersList parseUsers(List usersData) {
    if (usersData == null) return null;
    return UsersList.fromJson(usersData);
  }
}
