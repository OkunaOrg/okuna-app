class PostVideo {
  final String video;

  PostVideo({this.video});

  factory PostVideo.fromJSON(Map<String, dynamic> parsedJson) {
    return PostVideo(video: parsedJson['video']);
  }
}
