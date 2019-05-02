import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/services/storage.dart';

class UserPreferencesService {
  OBStorage _storage;
  static const postCommentsSortTypeStorageKey = 'postCommentsSortType';
  Future _getPostCommentsSortTypeCache;

  void setStorageService(StorageService storageService) {
    _storage = storageService.getSystemPreferencesStorage(namespace: 'userPreferences');
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
