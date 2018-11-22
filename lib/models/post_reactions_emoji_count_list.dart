import 'package:Openbook/models/post_reactions_emoji_count.dart';

class PostReactionsEmojiCountList {
  final List<PostReactionsEmojiCount> counts;

  PostReactionsEmojiCountList({
    this.counts,
  });

  factory PostReactionsEmojiCountList.fromJson(List<dynamic> parsedJson) {
    List<PostReactionsEmojiCount> postReactionsEmojiCounts = parsedJson
        .map((postJson) => PostReactionsEmojiCount.fromJson(postJson))
        .toList();

    return new PostReactionsEmojiCountList(
      counts: postReactionsEmojiCounts,
    );
  }
}
