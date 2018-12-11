import 'package:Openbook/models/user.dart';

class Circle {
  final int id;
  final User creator;
  final String name;
  final String color;

  Circle({this.id, this.creator, this.name, this.color});

  factory Circle.fromJSON(Map<String, dynamic> json) {
    return Circle(
        id: json['id'],
        creator: _parseUser(json['creator']),
        name: json['name'],
        color: json['color']);
  }

  static User _parseUser(Map userData) {
    if (userData == null) return null;
    return User.fromJson(userData);
  }
}
