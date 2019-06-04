import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/user.dart';

class ModerationPenalty {
  final User user;
  final DateTime expiration;
  final ModeratedObject moderatedObject;

  ModerationPenalty({this.user, this.expiration, this.moderatedObject});

  factory ModerationPenalty.fromJson(Map<String, dynamic> parsedJson) {
    return ModerationPenalty(
        user: parseUser(
          parsedJson['user'],
        ),
        moderatedObject: parseModeratedObject(
          parsedJson['moderated_object'],
        ),
        expiration: parseExpiration(parsedJson['expiration']));
  }

  static User parseUser(Map rawActor) {
    if (rawActor == null) return null;
    return User.fromJson(rawActor);
  }

  static ModerationCategory parseCategory(Map rawModerationCategory) {
    if (rawModerationCategory == null) return null;
    return ModerationCategory.fromJson(rawModerationCategory);
  }

  static DateTime parseExpiration(String expiration) {
    if (expiration == null) return null;
    return DateTime.parse(expiration).toLocal();
  }

  static ModeratedObject parseModeratedObject(Map rawModeratedObject) {
    if (rawModeratedObject == null) return null;
    return ModeratedObject.fromJSON(rawModeratedObject);
  }
}
