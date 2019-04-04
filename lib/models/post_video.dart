class PostVideo {
  final String video;
  final double width;
  final double height;

  PostVideo({this.video, this.width, this.height});

  factory PostVideo.fromJSON(Map<String, dynamic> parsedJson) {
    return PostVideo(
        video: parsedJson['video'],
        width: parsedJson['width']?.toDouble(),
        height: parsedJson['height']?.toDouble());
  }
}
