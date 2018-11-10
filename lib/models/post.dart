import 'package:Openbook/models/post-comment.dart';
import 'package:Openbook/models/post-comments-list.dart';
import 'package:Openbook/models/post-image.dart';

class Post {
  int id;
  int creatorId;
  String created;
  String text;
  PostImage image;
  PostCommentsList commentsList;

  Post(
      {this.id,
      this.created,
      this.text,
      this.creatorId,
      this.image,
      this.commentsList});

  factory Post.fromJson(Map<String, dynamic> parsedJson) {
    var postImageData = parsedJson['image'];
    var postImage;
    if (postImageData != null) postImage = PostImage.fromJSON(postImageData);

    var postCommentsData = parsedJson['comments'];
    var postComments;
    if (postCommentsData != null)
      postComments = PostCommentsList.fromJson(postCommentsData);

    return Post(
        id: parsedJson['id'],
        creatorId: parsedJson['creator_id'],
        created: parsedJson['email'],
        text: parsedJson['text'],
        image: postImage,
        commentsList: postComments);
  }

  bool hasImage() {
    return image != null;
  }

  bool hasText() {
    return text != null && text.length > 0;
  }

  bool hasComments() {
    return commentsList != null && commentsList.comments.length > 0;
  }

  List<PostComment> getPostComments() {
    return commentsList.comments;
  }
}
