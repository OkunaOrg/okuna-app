import 'package:Openbook/models/post_comment_reactions_emoji_count.dart';

class PostCommentReactionsEmojiCountList {
  final List<PostCommentReactionsEmojiCount> counts;

  PostCommentReactionsEmojiCountList({
    this.counts,
  });

  factory PostCommentReactionsEmojiCountList.fromJson(
      List<dynamic> parsedJson) {
    List<PostCommentReactionsEmojiCount> postCommentReactionsEmojiCounts =
        parsedJson
            .map((postCommentJson) =>
                PostCommentReactionsEmojiCount.fromJson(postCommentJson))
            .toList();

    return new PostCommentReactionsEmojiCountList(
      counts: postCommentReactionsEmojiCounts,
    );
  }
}
