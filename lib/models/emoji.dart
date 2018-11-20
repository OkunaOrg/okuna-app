class Emoji {
  final String keyword;
  final int id;
  final int order;
  final DateTime created;
  final String color;

  Emoji({this.keyword, this.id, this.order, this.created, this.color});

  factory Emoji.fromJson(Map<String, dynamic> parsedJson) {
    DateTime created = DateTime.parse(parsedJson['created']).toLocal();

    return Emoji(
        id: parsedJson['id'],
        keyword: parsedJson['keyword'],
        created: created,
        order: parsedJson['order'],
        color: parsedJson['color']);
  }
}
