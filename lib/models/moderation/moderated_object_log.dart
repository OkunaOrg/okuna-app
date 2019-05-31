import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/user.dart';

class ModeratedObjectLog {
  static String descriptionChangedLogType = 'DC';
  static String statusChangedLogType = 'SC';
  static String verifiedChangedLogType = 'VC';
  static String categoryChangedLogType = 'CC';

  final String description;
  final bool verified;
  final User actor;
  final DateTime created;
  ModeratedObjectLogType logType;

  ModeratedObjectLog(
      {this.verified,
      this.description,
      this.actor,
      this.created,
      this.logType});

  factory ModeratedObjectLog.fromJson(Map<String, dynamic> parsedJson) {
    return ModeratedObjectLog(
        verified: parsedJson['verified'],
        description: parsedJson['description'],
        actor: parseActor(
          parsedJson['actor'],
        ),
        logType: parseType(parsedJson['log_type']),
        created: parseCreated(parsedJson['created']));
  }

  static User parseActor(Map rawActor) {
    if (rawActor == null) return null;
    return User.fromJson(rawActor);
  }

  static DateTime parseCreated(String created) {
    if (created == null) return null;
    return DateTime.parse(created).toLocal();
  }

  static ModeratedObjectLogType parseType(String moderatedObjectTypeStr) {
    if (moderatedObjectTypeStr == null) return null;

    ModeratedObjectLogType moderatedObjectLogType;
    if (moderatedObjectTypeStr ==
        ModeratedObjectLog.descriptionChangedLogType) {
      moderatedObjectLogType = ModeratedObjectLogType.descriptionChanged;
    } else if (moderatedObjectTypeStr ==
        ModeratedObjectLog.statusChangedLogType) {
      moderatedObjectLogType = ModeratedObjectLogType.statusChanged;
    } else if (moderatedObjectTypeStr ==
        ModeratedObjectLog.verifiedChangedLogType) {
      moderatedObjectLogType = ModeratedObjectLogType.verifiedChanged;
    } else if (moderatedObjectTypeStr ==
        ModeratedObjectLog.categoryChangedLogType) {
      moderatedObjectLogType = ModeratedObjectLogType.categoryChanged;
    } else {
      print('Unsupported moderatedObjectLog type');
    }

    return moderatedObjectLogType;
  }
}

enum ModeratedObjectLogType {
  descriptionChanged,
  verifiedChanged,
  statusChanged,
  categoryChanged,
}

class ModeratedObjectCategoryChangedLog {
  final ModerationCategory changedFrom;
  final ModerationCategory changedTo;

  ModeratedObjectCategoryChangedLog({this.changedFrom, this.changedTo});
}

class ModeratedObjectDescriptionChangedLog {
  final String changedFrom;
  final String changedTo;

  ModeratedObjectDescriptionChangedLog({this.changedFrom, this.changedTo});
}

class ModeratedObjectVerifiedChangedLog {
  final bool changedFrom;
  final bool changedTo;

  ModeratedObjectVerifiedChangedLog({this.changedFrom, this.changedTo});
}

class ModeratedObjectStatusChangedLog {
  final ModeratedObjectStatus changedFrom;
  final ModeratedObjectStatus changedTo;

  ModeratedObjectStatusChangedLog({this.changedFrom, this.changedTo});
}
