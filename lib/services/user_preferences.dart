import 'package:Okuna/models/post_comment.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/services/storage.dart';
import 'package:rxdart/rxdart.dart';

class UserPreferencesService {
  OBStorage _storage;
  static const postCommentsSortTypeStorageKey = 'postCommentsSortType';
  static const videoAutoPlaySettingStorageKey = 'videoAutoPlaySetting';
  static const videoSoundSettingStorageKey = 'videoSoundSetting';
  Future _getPostCommentsSortTypeCache;

  Stream<VideosSoundSetting> get videosSoundSettingChange =>
      _videosSoundSettingChangeSubject.stream;

  final _videosSoundSettingChangeSubject =
  BehaviorSubject<VideosSoundSetting>();

  void setStorageService(StorageService storageService) {
    _storage = storageService.getSystemPreferencesStorage(
        namespace: 'userPreferences');
  }

  Future setVideoAutoPlaySetting(VideosAutoPlaySetting videoAutoPlaySetting) {
    String rawValue = videoAutoPlaySetting.toString();
    return _storage.set(videoAutoPlaySettingStorageKey, rawValue);
  }

  Future<VideosAutoPlaySetting> getVideoAutoPlaySetting() async {
    String rawValue = await _storage.get(videoAutoPlaySettingStorageKey,
        defaultValue: VideosAutoPlaySetting.wifiOnly.toString());
    return VideosAutoPlaySetting.parse(rawValue);
  }

  Future setVideoSoundSetting(VideosSoundSetting videoSoundSetting) {
    String rawValue = videoSoundSetting.toString();
    _videosSoundSettingChangeSubject.add(videoSoundSetting);
    return _storage.set(videoSoundSettingStorageKey, rawValue);
  }

  Future<VideosSoundSetting> getVideoSoundSetting() async {
    String rawValue = await _storage.get(videoSoundSettingStorageKey,
        defaultValue: VideosSoundSetting.disabled.toString());
    return VideosSoundSetting.parse(rawValue);
  }

  Future setPostCommentsSortType(PostCommentsSortType type) {
    _getPostCommentsSortTypeCache = null;
    String rawType = PostComment.convertPostCommentSortTypeToString(type);
    return _storage.set(postCommentsSortTypeStorageKey, rawType);
  }

  Future<PostCommentsSortType> getPostCommentsSortType() async {
    if (_getPostCommentsSortTypeCache != null)
      return _getPostCommentsSortTypeCache;
    _getPostCommentsSortTypeCache = _getPostCommentsSortType();
    return _getPostCommentsSortTypeCache;
  }

  Future<PostCommentsSortType> _getPostCommentsSortType() async {
    String rawType = await _storage.get(postCommentsSortTypeStorageKey);
    if (rawType == null) {
      PostCommentsSortType defaultSortType = _getDefaultPostCommentsSortType();
      await setPostCommentsSortType(defaultSortType);
      return defaultSortType;
    }
    return PostComment.parsePostCommentSortType(rawType);
  }

  PostCommentsSortType _getDefaultPostCommentsSortType() {
    return PostCommentsSortType.asc;
  }

  Future clear() {
    return _storage.clear();
  }
}

class VideosAutoPlaySetting {
  final String code;

  const VideosAutoPlaySetting._internal(this.code);

  toString() => code;

  static const never = const VideosAutoPlaySetting._internal('n');
  static const always = const VideosAutoPlaySetting._internal('a');
  static const wifiOnly = const VideosAutoPlaySetting._internal('w');

  static const _values = const <VideosAutoPlaySetting>[never, always, wifiOnly];

  static values() => _values;

  static VideosAutoPlaySetting parse(String string) {
    if (string == null) return null;

    VideosAutoPlaySetting autoPlaySetting;
    for (var type in _values) {
      if (string == type.code) {
        autoPlaySetting = type;
        break;
      }
    }

    if (autoPlaySetting == null) {
      // Don't throw as we might introduce new notifications on the API which might not be yet in code
      print('Unsupported autoplay setting');
    }

    return autoPlaySetting;
  }
}

class VideosSoundSetting {
  final String code;

  const VideosSoundSetting._internal(this.code);

  toString() => code;

  static const enabled = const VideosSoundSetting._internal('e');
  static const disabled = const VideosSoundSetting._internal('d');

  static const _values = const <VideosSoundSetting>[enabled, disabled];

  static values() => _values;

  static VideosSoundSetting parse(String string) {
    if (string == null) return null;

    VideosSoundSetting soundSetting;
    for (var type in _values) {
      if (string == type.code) {
        soundSetting = type;
        break;
      }
    }

    if (soundSetting == null) {
      // Don't throw as we might introduce new notifications on the API which might not be yet in code
      print('Unsupported videos sound setting');
    }

    return soundSetting;
  }
}
