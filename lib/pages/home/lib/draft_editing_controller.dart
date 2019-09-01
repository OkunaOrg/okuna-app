import 'package:Okuna/services/draft.dart';
import 'package:flutter/material.dart';

class DraftTextEditingController extends TextEditingController {
  final int postId;
  final int commentId;
  final DraftService _draftService;

  DraftTextEditingController.comment(this.postId,
      {int commentId, String text, @required DraftService draftService})
      : this._draftService = draftService,
        this.commentId = commentId ?? -1,
        super(text: text) {
    if (text == null) {
      this.text = _draftService.getCommentDraft(postId, commentId);
    }

    addListener(_textChanged);
  }

  void _textChanged() {
    _draftService.setCommentDraft(
        text, postId, commentId != -1 ? commentId : null);
  }

  void clearDraft() {
    _draftService.removeCommentDraft(
        postId, commentId != -1 ? commentId : null);
  }
}
