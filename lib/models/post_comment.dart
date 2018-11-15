import 'package:Openbook/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostComment {
  final int id;
  final int creatorId;
  final DateTime created;
  final String text;
  final User commenter;

  PostComment(
      {this.id, this.created, this.text, this.creatorId, this.commenter});

  factory PostComment.fromJson(Map<String, dynamic> parsedJson) {
    DateTime created = DateTime.parse(parsedJson['created']).toLocal();

    User commenter = User.fromJson(parsedJson['commenter']);

    return PostComment(
        id: parsedJson['id'],
        creatorId: parsedJson['creator_id'],
        created: created,
        commenter: commenter,
        text: parsedJson['text']);
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }

  String getCommenterUsername() {
    return this.commenter.username;
  }
}
