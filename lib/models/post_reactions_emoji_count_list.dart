import 'package:Openbook/models/post_reactions_emoji_count.dart';

class PostReactionsEmojiCountList {
  final List<PostReactionsEmojiCount> reactions;

  PostReactionsEmojiCountList({
    this.reactions,
  });

  factory PostReactionsEmojiCountList.fromJson(List<dynamic> parsedJson) {
    List<PostReactionsEmojiCount> postReactionsEmojiCounts = parsedJson
        .map((postJson) => PostReactionsEmojiCount.fromJson(postJson))
        .toList();

    return new PostReactionsEmojiCountList(
      reactions: postReactionsEmojiCounts,
    );
  }
}
