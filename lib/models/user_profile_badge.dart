import 'package:Openbook/models/badge.dart';

class UserProfileBadge {
  final Badge badge;

  UserProfileBadge(
      {
        this.badge
      });

  factory UserProfileBadge.fromJson(Map<String, dynamic> parsedJson) {
    Badge badge = Badge.fromJson(parsedJson['badge']);

    return UserProfileBadge(
        badge: badge,
    );
  }

  BadgeKeyword getKeyword() {
    return this.badge.getKeyword();
  }

  String getKeywordDescription() {
    return this.badge.getKeywordDescription();
  }
}
