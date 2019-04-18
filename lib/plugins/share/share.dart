class Share {
  static const String PATH = 'path';
  static const String TEXT = 'text';

  final String path;
  final String text;

  const Share({
    this.path,
    this.text,
  });

  static Share fromReceived(Map received) {
    String text;
    String path;
    if (received.containsKey(TEXT)) {
      text = received[TEXT];
    }
    if (received.containsKey(PATH)) {
      path = received[PATH];
    }
    return Share(path: path, text: text);
  }
}
