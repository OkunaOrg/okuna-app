import 'package:Okuna/models/post_comment.dart';
import 'package:Okuna/services/storage.dart';
import 'package:public_suffix/public_suffix.dart';

class UserPreferencesService {
  static const keyAskToConfirmOpen = 'askToConfirmOpen';
  static const keyAskToConfirmExceptions = 'askToConfirmExceptions';

  OBStorage _storage;
  static const postCommentsSortTypeStorageKey = 'postCommentsSortType';
  Future _getPostCommentsSortTypeCache;

  void setStorageService(StorageService storageService) {
    _storage = storageService.getSystemPreferencesStorage(
        namespace: 'userPreferences');
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

  Future setAskToConfirmOpenUrl(bool ask,
      {PublicSuffix host, String hostAsString}) async {
    var domain = (host != null ? host.domain : hostAsString);
    domain = domain?.toLowerCase();

    Future status = Future.value(true);
    if (host == null && hostAsString == null) {
      status = _storage?.set(keyAskToConfirmOpen, ask.toString());
    } else if (domain != null) {
      List<String> exceptions =
          await _storage?.getList(keyAskToConfirmExceptions) ?? <String>[];

      var hasException = exceptions.contains(domain);

      if (!hasException && !ask) {
        exceptions.add(domain);
        status = _storage?.setList(keyAskToConfirmExceptions, exceptions);
      } else if (hasException && ask) {
        exceptions.remove(domain);
        status = _storage?.setList(keyAskToConfirmExceptions, exceptions);
      }
    }

    return status;
  }

  Future<bool> getAskToConfirmOpenUrl({PublicSuffix host}) async {
    String ask = await _storage?.get(keyAskToConfirmOpen);
    bool shouldAsk = true;

    if (ask != null && ask.toLowerCase() == "false") {
      shouldAsk = false;
    } else if (host != null && host.domain != null) {
      List<String> exceptions =
          await _storage?.getList(keyAskToConfirmExceptions);

      if (exceptions != null &&
          exceptions.contains(host.domain.toLowerCase())) {
        shouldAsk = false;
      }
    }

    return shouldAsk;
  }

  Future<List<String>> getTrustedDomains() async {
    var domains = await _storage?.getList(keyAskToConfirmExceptions);
    return domains ?? <String>[];
  }

  Future clear() {
    return _storage.clear();
  }
}
