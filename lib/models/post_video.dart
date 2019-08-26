import 'package:Okuna/models/video_format.dart';
import 'package:Okuna/models/video_formats_list.dart';

class PostVideo {
  final int id;
  final double width;
  final double height;
  final double duration;
  final String file;
  final String thumbnail;
  final int thumbnailHeight;
  final int thumbnailWidth;
  final OBVideoFormatsList formatSet;

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

  OBVideoFormat getVideoFormatOfType(OBVideoFormatType type) {
    return formatSet.videoFormats.firstWhere((OBVideoFormat format) {
      return format.type == type;
    });
  }

  factory PostVideo.fromJSON(Map<String, dynamic> parsedJson) {
    return PostVideo(
      width: parsedJson['width'],
      height: parsedJson['height'],
      duration: parsedJson['duration'],
      file: parsedJson['file'],
      formatSet: parseFormatSet(parsedJson['format_set']),
      thumbnail: parsedJson['thumbnail'],
      thumbnailWidth: parsedJson['thumbnail_width'],
      thumbnailHeight: parsedJson['thumbnail_height'],
    );
  }

  static OBVideoFormatsList parseFormatSet(List rawData) {
    if (rawData == null) return null;
    return OBVideoFormatsList.fromJson(rawData);
  }
}
