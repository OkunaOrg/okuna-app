import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostComment {
  static convertPostCommentSortTypeToString(PostCommentsSortType type) {
    String result;
    switch (type) {
      case PostCommentsSortType.asc:
        result = 'ASC';
        break;
      case PostCommentsSortType.dec:
        result = 'DESC';
        break;
      default:
        throw 'Unsupported post comment sort type';
    }
    return result;
  }

  static PostCommentsSortType parsePostCommentSortType(String sortType) {
    PostCommentsSortType type;
    if (sortType == 'ASC') {
      type = PostCommentsSortType.asc;
    }

    if (sortType == 'DESC') {
      type = PostCommentsSortType.dec;
    }

    return type;
  }

  final int id;
  final int creatorId;
  final DateTime created;
  final String text;
  final User commenter;
  final Post post;
  final bool isEdited;

  PostComment({
    this.id,
    this.created,
    this.text,
    this.creatorId,
    this.commenter,
    this.post,
    this.isEdited
  });

  factory PostComment.fromJson(Map<String, dynamic> parsedJson) {
    DateTime created;
    if (parsedJson.containsKey('created')) {
      created = DateTime.parse(parsedJson['created']).toLocal();
    }

    User commenter;
    if (parsedJson.containsKey('commenter')) {
      commenter = User.fromJson(parsedJson['commenter']);
    }

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
        isEdited: parsedJson['is_edited'],
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

  int getPostCreatorId() {
    return post.getCreatorId();
  }
}

enum PostCommentsSortType { asc, dec }
