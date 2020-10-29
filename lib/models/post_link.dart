import 'package:Okuna/models/updatable_model.dart';
import 'package:dcache/dcache.dart';

class PostLink extends UpdatableModel<PostLink> {
  final int id;
  String link;
  bool hasPreview;

  PostLink({
    this.id,
    this.link,
    this.hasPreview,
  });

  static final factory = PostLinkFactory();

  factory PostLink.fromJSON(Map<String, dynamic> json) {
    if (json == null) return null;
    return factory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'link': link,
      'has_preview': hasPreview,
    };
  }

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('link')) {
      link = json['link'];
    }

    if (json.containsKey('has_preview')) {
      hasPreview = json['has_preview'];
    }
  }
}

class PostLinkFactory extends UpdatableModelFactory<PostLink> {
  @override
  SimpleCache<int, PostLink> cache =
      SimpleCache(storage: UpdatableModelSimpleStorage(size: 20));

  @override
  PostLink makeFromJson(Map json) {
    return PostLink(
      id: json['id'],
      link: json['link'],
      hasPreview: json['has_preview'],
    );
  }
}
