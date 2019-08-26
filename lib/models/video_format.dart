class VideoFormat{
  final int id;
  final double progress;
  final double duration;
  final String format;
  final String file;

  const VideoFormat({this.id, this.progress, this.duration, this.format, this.file});

  factory VideoFormat.fromJSON(Map<String, dynamic> json) {
    return VideoFormat(
      id : json['int'],
      progress : json['progress'],
      duration : json['duration'],
      format : json['format'],
      file : json['file'],
    );
  }
}