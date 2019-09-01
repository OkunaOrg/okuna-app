import 'dart:collection';

class DraftService {
  static const _maxSavedDrafts = 25;

  LinkedHashMap<String, String> _commentDrafts = LinkedHashMap();
  String _postDraft;

  String getCommentDraft(int postId, [int commentId]) =>
      _commentDrafts[_buildKey(postId, commentId)] ?? '';

  String getPostDraft() => _postDraft ?? '';

  void setCommentDraft(String text, int postId, [int commentId]) {
    if (text.trim().isNotEmpty) {
      String key = _buildKey(postId, commentId);
      _commentDrafts.update(key, (e) => text, ifAbsent: () => text);

      if (_commentDrafts.length > _maxSavedDrafts) {
        _commentDrafts.remove(_commentDrafts.keys.first);
      }
    } else {
      removeCommentDraft(postId, commentId);
    }
  }

  void removeCommentDraft(int postId, [commentId]) {
    _commentDrafts.remove(_buildKey(postId, commentId));
  }

  void setPostDraft(String text) => _postDraft = text;

  void clear() {
    _commentDrafts.clear();
    _postDraft = '';
  }

  String _buildKey(int postId, int commentId) => '$postId|${commentId ?? "-1"}';
}
