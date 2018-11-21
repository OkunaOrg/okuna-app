import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/post_comment_list.dart';
import 'package:Openbook/models/post_image.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/post_reactions_emoji_count.dart';
import 'package:Openbook/models/post_reactions_emoji_count_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post {
  final int id;
  final int creatorId;
  final int reactionsCount;
  final int commentsCount;
  final DateTime created;
  final String text;
  final PostImage image;
  final PostCommentList commentsList;
  final User creator;
  PostReactionsEmojiCountList reactionsEmojiCounts;
  bool reacted;
  bool commented;

  Post(
      {this.id,
      this.created,
      this.text,
      this.creatorId,
      this.image,
      this.creator,
      this.reactionsCount,
      this.commentsCount,
      this.commentsList,
      this.reacted,
      this.commented,
      this.reactionsEmojiCounts});

  factory Post.fromJson(Map<String, dynamic> parsedJson) {
    var postImageData = parsedJson['image'];
    var postImage;
    if (postImageData != null) postImage = PostImage.fromJSON(postImageData);

    var postCreatorData = parsedJson['creator'];
    var postCreator;
    if (postCreatorData != null) postCreator = User.fromJson(postCreatorData);

    var reactionsEmojiCountsData = parsedJson['reactions_emoji_counts'];
    var reactionsEmojiCounts;
    if (reactionsEmojiCountsData != null)
      reactionsEmojiCounts =
          PostReactionsEmojiCountList.fromJson(reactionsEmojiCountsData);

    var postCommentsData = parsedJson['comments'];
    var postComments;
    if (postCommentsData != null)
      postComments = PostCommentList.fromJson(postCommentsData);

    DateTime created = DateTime.parse(parsedJson['created']).toLocal();

    return Post(
        id: parsedJson['id'],
        creatorId: parsedJson['creator_id'],
        created: created,
        reacted: parsedJson['reacted'],
        commented: parsedJson['commented'],
        text: parsedJson['text'],
        reactionsCount: parsedJson['reactions_count'],
        commentsCount: parsedJson['comments_count'],
        creator: postCreator,
        image: postImage,
        commentsList: postComments,
        reactionsEmojiCounts: reactionsEmojiCounts);
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

  bool hasCommentsCount() {
    return commentsCount != null && commentsCount > 0;
  }

  List<PostComment> getPostComments() {
    return commentsList.comments;
  }

  List<PostReactionsEmojiCount> getEmojiCounts(){
    return reactionsEmojiCounts.reactions.toList();
  }

  String getCreatorUsername() {
    return creator.username;
  }

  int getCreatorId() {
    return creator.id;
  }

  String getCreatorAvatar() {
    return creator.profile.avatar;
  }

  String getImage() {
    return image.image;
  }

  String getText() {
    return text;
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }
}
