import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCommentReaction {
  final int id;
  final DateTime created;
  final Emoji emoji;
  final User reactor;
  final PostComment postComment;

  PostCommentReaction(
      {this.id, this.created, this.emoji, this.reactor, this.postComment});

  factory PostCommentReaction.fromJson(Map<String, dynamic> parsedJson) {
    DateTime created;
    var createdData = parsedJson['created'];
    if (createdData != null) created = DateTime.parse(createdData).toLocal();

    User reactor;
    var reactorData = parsedJson['reactor'];
    if (reactorData != null) reactor = User.fromJson(reactorData);

    PostComment postComment;
    if (parsedJson.containsKey('postComment')) {
      postComment = PostComment.fromJSON(parsedJson['postComment']);
    }

    Emoji emoji = Emoji.fromJson(parsedJson['emoji']);

    return PostCommentReaction(
        id: parsedJson['id'],
        created: created,
        reactor: reactor,
        emoji: emoji,
        postComment: postComment);
  }

  String getRelativeCreated() {
    return timeago.format(created);
  }

  String getReactorUsername() {
    return this.reactor.username;
  }

  String getReactorProfileAvatar() {
    return this.reactor.getProfileAvatar();
  }

  int getReactorId() {
    return this.reactor.id;
  }

  int getEmojiId() {
    return this.emoji.id;
  }

  String getEmojiImage() {
    return this.emoji.image;
  }

  String getEmojiKeyword() {
    return this.emoji.keyword;
  }

  PostCommentReaction copy({Emoji newEmoji}) {
    return PostCommentReaction(emoji: newEmoji ?? emoji);
  }
}
