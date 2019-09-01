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

  DraftTextEditingController.post(DraftService draftService, {String text})
      : postId = -1,
        commentId = -1,
        this._draftService = draftService,
        super(text: text) {
    if (text == null) {
      this.text = _draftService.getPostDraft();
    }

    addListener(_textChanged);
  }

  void _textChanged() {
    if (postId != -1) {
      _draftService.setCommentDraft(
          text, postId, commentId != -1 ? commentId : null);
    } else {
      _draftService.setPostDraft(text);
    }
  }

  void clearDraft() {
    if (postId != -1) {
      _draftService.removeCommentDraft(
          postId, commentId != -1 ? commentId : null);
    } else {
      _draftService.setPostDraft(null);
    }
  }
}
