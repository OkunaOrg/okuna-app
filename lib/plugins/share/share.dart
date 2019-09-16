class Share {
  static const String IMAGE = 'image';
  static const String VIDEO = 'video';
  static const String TEXT = 'text';

  final String image;
  final String video;
  final String text;

  const Share({
    this.image,
    this.video,
    this.text
  });

  static Share fromReceived(Map received) {
    String text;
    String image;
    String video;
    if (received.containsKey(TEXT)) {
      text = received[TEXT];
    }
    if (received.containsKey(IMAGE)) {
      image = received[IMAGE];
    }
    if (received.containsKey(VIDEO)) {
      video = received[VIDEO];
    }
    return Share(image: image, video: video, text: text);
  }
}
