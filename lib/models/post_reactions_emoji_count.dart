import 'package:Openbook/models/emoji.dart';

class PostReactionsEmojiCount {
  final Emoji emoji;
  final int count;

  PostReactionsEmojiCount({this.emoji, this.count});

  factory PostReactionsEmojiCount.fromJson(Map<String, dynamic> parsedJson) {
    Emoji emoji = Emoji.fromJson(parsedJson['emoji']);

    return PostReactionsEmojiCount(emoji: emoji, count: parsedJson['count']);
  }

  PostReactionsEmojiCount copy({newEmoji, newCount, newReacted}) {
    return PostReactionsEmojiCount(
        emoji: newEmoji ?? this.emoji, count: newCount ?? this.count);
  }

  String getPrettyCount() {
    return count.toString();
  }

  int getEmojiId() {
    return emoji.id;
  }
}
