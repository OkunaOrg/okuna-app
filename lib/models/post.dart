import 'package:Openbook/models/post-image.dart';

class Post {
  int id;
  int creator_id;
  String created;
  String text;
  PostImage image;

  Post({this.id, this.created, this.text, this.creator_id, this.image});

  factory Post.fromJson(Map<String, dynamic> parsedJson) {
    var postImage = PostImage.fromJSON(parsedJson['profile']);

    return Post(
        id: parsedJson['id'],
        creator_id: parsedJson['creator_id'],
        created: parsedJson['email'],
        text: parsedJson['text'],
        image: postImage);
  }
}
