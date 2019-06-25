import 'package:Openbook/models/emoji.dart';

class PostCommentReactionsEmojiCount {
  final Emoji emoji;
  int count;

  PostCommentReactionsEmojiCount({this.emoji, this.count});

  factory PostCommentReactionsEmojiCount.fromJson(Map<String, dynamic> parsedJson) {
    Emoji emoji = Emoji.fromJson(parsedJson['emoji']);

    return PostCommentReactionsEmojiCount(emoji: emoji, count: parsedJson['count']);
  }

  PostCommentReactionsEmojiCount copy({newEmoji, newCount, newReacted}) {
    return PostCommentReactionsEmojiCount(
        emoji: newEmoji ?? this.emoji, count: newCount ?? this.count);
  }

  String getPrettyCount() {
    return count.toString();
  }

  int getEmojiId() {
    return emoji.id;
  }
}
