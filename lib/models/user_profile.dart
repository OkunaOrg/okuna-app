import 'package:Openbook/models/user_profile_badge.dart';

class UserProfile {
  final int id;
  String name;
  DateTime birthDate;
  String avatar;
  String cover;
  String bio;
  String url;
  String location;
  bool followersCountVisible;
  List<UserProfileBadge> badges;

  UserProfile(
      {this.id,
      this.name,
      this.birthDate,
      this.avatar,
      this.cover,
      this.bio,
      this.url,
      this.location,
      this.badges,
      this.followersCountVisible});

  factory UserProfile.fromJSON(Map<String, dynamic> parsedJson) {
    var birthDateData = parsedJson['birth_date'];
    var birthDate;
    if (birthDateData != null) birthDate = DateTime.parse(birthDateData);
    List<dynamic> badges = parsedJson['badges'];

    var badgesList = badges.map((badgeJson) => UserProfileBadge.fromJson(badgeJson)).toList();
    print(badgesList);

    return UserProfile(
        id: parsedJson['id'],
        name: parsedJson['name'],
        birthDate: birthDate,
        avatar: parsedJson['avatar'],
        cover: parsedJson['cover'],
        bio: parsedJson['bio'],
        url: parsedJson['url'],
        location: parsedJson['location'],
        badges: badgesList,
        followersCountVisible: parsedJson['followers_count_visible']);
  }

  void updateFromJson(Map<String, dynamic> json) {
    if (json.containsKey('name')) name = json['name'];
    if (json.containsKey('avatar')) avatar = json['avatar'];
    if (json.containsKey('cover')) cover = json['cover'];
    if (json.containsKey('bio')) bio = json['bio'];
    if (json.containsKey('url')) url = json['url'];
    if (json.containsKey('location')) location = json['location'];
    if (json.containsKey('followers_count_visible'))
      followersCountVisible = json['followers_count_visible'];
    if (json.containsKey('birth_date')) {
      birthDate = DateTime.parse(json['birth_date']);
    }
  }

  bool hasLocation() {
    return location != null;
  }

  bool hasUrl() {
    return url != null;
  }
}
