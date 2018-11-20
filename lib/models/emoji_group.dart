import 'package:Openbook/models/emoji_list.dart';

class EmojiGroup {
  final String keyword;
  final int id;
  final int order;
  final DateTime created;
  final String color;
  final EmojisList emojis;

  EmojiGroup(
      {this.keyword,
      this.id,
      this.order,
      this.created,
      this.color,
      this.emojis});

  factory EmojiGroup.fromJson(Map<String, dynamic> parsedJson) {
    DateTime created = DateTime.parse(parsedJson['created']).toLocal();

    var emojisData = parsedJson['emojis'];
    EmojisList emojis = EmojisList.fromJson(emojisData);

    return EmojiGroup(
        id: parsedJson['id'],
        keyword: parsedJson['keyword'],
        created: created,
        order: parsedJson['order'],
        color: parsedJson['color'],
        emojis: emojis);
  }
}
