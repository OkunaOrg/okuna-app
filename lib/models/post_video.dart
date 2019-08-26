import 'package:Okuna/models/video_format.dart';

class PostVideo {
  final int id;
  final double width;
  final double height;
  final double duration;
  final String file;
  final String thumbnail;
  final int thumbnailHeight;
  final int thumbnailWidth;
  final List<VideoFormat> formatSet;

  const PostVideo({
    this.id,
    this.width,
    this.height,
    this.duration,
    this.file,
    this.formatSet,
    this.thumbnail,
    this.thumbnailHeight,
    this.thumbnailWidth,
  });

  factory PostVideo.fromJSON(Map<String, dynamic> parsedJson) {
    List<Map> formatSetRawData = parsedJson['format_set'];

    List<VideoFormat> formatSet =
        formatSetRawData.map((Map formatSetItemRawData) {
      return VideoFormat.fromJSON(formatSetItemRawData);
    }).toList();

    return PostVideo(
      width: parsedJson['width'],
      height: parsedJson['height'],
      duration: parsedJson['duration'],
      file: parsedJson['file'],
      formatSet: formatSet,
      thumbnail: parsedJson['thumbnail'],
      thumbnailWidth: parsedJson['thumbnail_width'],
      thumbnailHeight: parsedJson['thumbnail_height'],
    );
  }
}
