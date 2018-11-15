import 'package:Openbook/models/post_comment.dart';

class PostCommentsList {
  final List<PostComment> comments;

  PostCommentsList({
    this.comments,
  });

  factory PostCommentsList.fromJson(List<dynamic> parsedJson) {
    List<PostComment> postComments =
        parsedJson.map((postJson) => PostComment.fromJson(postJson)).toList();

    return new PostCommentsList(
      comments: postComments,
    );
  }
}
