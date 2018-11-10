class PostImage {
  String image;

  PostImage({this.image});

  factory PostImage.fromJSON(Map<String, dynamic> parsedJson) {
    return PostImage(image: parsedJson['image']);
  }
}
