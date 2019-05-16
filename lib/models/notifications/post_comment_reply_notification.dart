import 'package:Openbook/models/post_comment.dart';

class PostCommentReplyNotification {
  final int id;
  final PostComment postComment;
  final PostComment parentComment;

  PostCommentReplyNotification({this.id, this.postComment, this.parentComment});

  factory PostCommentReplyNotification.fromJson(Map<String, dynamic> json) {
    return PostCommentReplyNotification(
        id: json['id'],
        postComment: _parsePostComment(json['post_comment']),
        parentComment: _parsePostComment(json['parent_comment'])
    );
  }

  static PostComment _parsePostComment(Map postCommentData) {
    return PostComment.fromJSON(postCommentData);
  }

  int getPostCreatorId() {
    return postComment.getPostCreatorId();
  }
}
