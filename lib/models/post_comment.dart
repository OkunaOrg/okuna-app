import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostComment {
  final int id;
  final int creatorId;
  final DateTime created;
  final String text;
  final User commenter;
  final Post post;

  PostComment({
    this.id,
    this.created,
    this.text,
    this.creatorId,
    this.commenter,
    this.post,
  });

  factory PostComment.fromJson(Map<String, dynamic> parsedJson) {
    DateTime created;
    if (parsedJson.containsKey('created')) {
      created = DateTime.parse(parsedJson['created']).toLocal();
    }

    User commenter = User.fromJson(parsedJson['commenter']);

    Post post;
    if (parsedJson.containsKey('post')) {
      post = Post.fromJson(parsedJson['post']);
    }

    return PostComment(
        id: parsedJson['id'],
        creatorId: parsedJson['creator_id'],
        created: created,
        commenter: commenter,
        post: post,
        text: parsedJson['text']);
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }

  String getCommenterUsername() {
    return this.commenter.username;
  }

  String getCommenterName() {
    return this.commenter.getProfileName();
  }

  String getCommenterProfileAvatar() {
    return this.commenter.getProfileAvatar();
  }

  int getCommenterId() {
    return this.commenter.id;
  }
}
