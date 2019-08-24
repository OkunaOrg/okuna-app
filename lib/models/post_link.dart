class PostLink {
  final String link;

  PostLink({this.link});

  factory PostLink.fromJson(Map<String, dynamic> parsedJson) {
    return PostLink(
        link: parsedJson['link'],
    );
  }
}
