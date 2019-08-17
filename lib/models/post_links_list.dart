import 'package:Okuna/models/post_link.dart';

class PostLinksList {
  final List<PostLink> links;

  PostLinksList({
    this.links,
  });

  factory PostLinksList.fromJson(List<dynamic> parsedJson) {
    List<PostLink> links =
    parsedJson.map((postJson) => PostLink.fromJson(postJson)).toList();

    return new PostLinksList(
      links: links,
    );
  }
}
