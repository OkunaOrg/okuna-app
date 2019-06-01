import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/user.dart';

class ModerationReport {
  final ModerationCategory category;
  final String description;
  final User reporter;
  final DateTime created;

  ModerationReport(
      {this.description, this.reporter, this.category, this.created});

  factory ModerationReport.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson);
    return ModerationReport(
        description: parsedJson['description'],
        reporter: parseReporter(
          parsedJson['reporter'],
        ),
        category: parseCategory(
          parsedJson['category'],
        ),
        created: parseCreated(parsedJson['created']));
  }

  static User parseReporter(Map rawActor) {
    if (rawActor == null) return null;
    return User.fromJson(rawActor);
  }

  static ModerationCategory parseCategory(Map rawModerationCategory) {
    if (rawModerationCategory == null) return null;
    print('PARSIN');
    print(rawModerationCategory);
    return ModerationCategory.fromJson(rawModerationCategory);
  }

  static DateTime parseCreated(String created) {
    if (created == null) return null;
    return DateTime.parse(created).toLocal();
  }
}
