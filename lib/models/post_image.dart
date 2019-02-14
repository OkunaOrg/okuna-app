class PostImage {
  final String url;
  final double width;
  final double height;

  PostImage({this.url, this.width, this.height});

  factory PostImage.fromJSON(Map<String, dynamic> parsedJson) {
    return PostImage(url: parsedJson['url'], width: parsedJson['width'].toDouble(), height: parsedJson['height'].toDouble());
  }
}
