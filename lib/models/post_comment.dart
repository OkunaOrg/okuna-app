class PostComment {
  int id;
  int creatorId;
  String created;
  String text;

  PostComment({this.id, this.created, this.text, this.creatorId});

  factory PostComment.fromJson(Map<String, dynamic> parsedJson) {
    return PostComment(
        id: parsedJson['id'],
        creatorId: parsedJson['creator_id'],
        created: parsedJson['created'],
        text: parsedJson['text']);
  }
}
