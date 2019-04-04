class Share {
  static const String PATH = 'path';
  static const String TITLE = 'title';
  static const String TEXT = 'text';

  final String path;
  final String title;
  final String text;

  const Share.image({
    this.path,
    this.title,
    this.text,
  }) : assert(path != null);

  static Share fromReceived(Map received) {
    if (received.containsKey(TITLE)) {
      if (received.containsKey(TEXT)) {
        return Share.image(
            path: received[PATH], title: received[TITLE], text: received[TEXT]);
      } else {
        return Share.image(path: received[PATH], title: received[TITLE]);
      }
    } else {
      return Share.image(path: received[PATH]);
    }
  }
}
