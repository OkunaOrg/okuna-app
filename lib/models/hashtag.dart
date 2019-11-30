import 'package:Okuna/models/emoji.dart';
import 'package:Okuna/models/updatable_model.dart';
import 'package:dcache/dcache.dart';

class Hashtag extends UpdatableModel<Hashtag> {
  final int id;
  String name;
  String image;
  Emoji emoji;
  String color;
  int postsCount;

  Hashtag({
    this.id,
    this.name,
    this.image,
    this.emoji,
    this.color,
    this.postsCount,
  });

  static final factory = HashtagFactory();

  factory Hashtag.fromJSON(Map<String, dynamic> json) {
    if (json == null) return null;
    return factory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'image': image,
      'color': color,
      'posts_count': postsCount,
    };
  }

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('name')) {
      name = json['name'];
    }
    if (json.containsKey('posts_count')) {
      postsCount = json['posts_count'];
    }
    if (json.containsKey('color')) {
      color = json['color'];
    }

    if (json.containsKey('image')) {
      image = json['image'];
    }

    if (json.containsKey('emoji')) {
      emoji = factory.parseEmoji(json['emoji']);
    }
  }

  bool hasEmoji() {
    return this.emoji != null;
  }

  bool hasImage() {
    return this.image != null;
  }
}

class HashtagFactory extends UpdatableModelFactory<Hashtag> {
  @override
  SimpleCache<int, Hashtag> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 20));

  @override
  Hashtag makeFromJson(Map json) {
    return Hashtag(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      emoji: parseEmoji(json['emoji']),
      postsCount: json['posts_count'],
    );
  }

  Emoji parseEmoji(emojiRawData) {
    if (emojiRawData == null) return null;
    return Emoji.fromJson(emojiRawData);
  }
}
