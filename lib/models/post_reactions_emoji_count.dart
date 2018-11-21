import 'package:Openbook/models/emoji.dart';

class PostReactionsEmojiCount {
  final Emoji emoji;
  final int count;
  final bool reacted;

  PostReactionsEmojiCount({this.emoji, this.count, this.reacted});

  factory PostReactionsEmojiCount.fromJson(Map<String, dynamic> parsedJson) {
    Emoji emoji = Emoji.fromJson(parsedJson['emoji']);

    return PostReactionsEmojiCount(
        emoji: emoji,
        count: parsedJson['count'],
        reacted: parsedJson['reacted']);
  }

  PostReactionsEmojiCount copy({newEmoji, newCount, newReacted}) {
    return PostReactionsEmojiCount(
        emoji: newEmoji ?? this.emoji,
        count: newCount ?? this.count,
        reacted: newReacted != null ? newReacted : this.reacted);
  }

  String getPrettyCount() {
    return count.toString();
  }
}
