class PostImage {
  final String image;
  final double width;
  final double height;

  PostImage({this.image, this.width, this.height});

  factory PostImage.fromJSON(Map<String, dynamic> parsedJson) {
    return PostImage(
        image: parsedJson['image'],
        width: parsedJson['width']?.toDouble(),
        height: parsedJson['height']?.toDouble());
  }
}
