import 'package:Okuna/services/draft.dart';
import 'package:flutter/material.dart';

abstract class DraftTextEditingController extends TextEditingController {
  final DraftService _draftService;

  DraftTextEditingController(this._draftService) {
    addListener(_textChanged);
  }

  factory DraftTextEditingController.comment(int postId,
      {int commentId, String text, @required DraftService draftService}) {
    return _CommentDraftEditingController(
        postId, commentId, text, draftService);
  }

  factory DraftTextEditingController.post(
      {int communityId, String text, @required DraftService draftService}) {
    return _PostDraftEditingController(communityId, text, draftService);
  }

  void _textChanged();

  void clearDraft();
}

class _CommentDraftEditingController extends DraftTextEditingController {
  final int postId;
  final int commentId;

  _CommentDraftEditingController(
      this.postId, this.commentId, String text, DraftService draftService)
      : super(draftService) {
    if (text == null) {
      this.text = _draftService.getCommentDraft(postId, commentId);
    }
  }

  void _textChanged() {
    _draftService.setCommentDraft(text, postId, commentId);
  }

  void clearDraft() {
    _draftService.removeCommentDraft(postId, commentId);
  }
}

class _PostDraftEditingController extends DraftTextEditingController {
  final int communityId;

  _PostDraftEditingController(
      this.communityId, String text, DraftService draftService)
      : super(draftService) {
    if (text == null) {
      this.text = _draftService.getPostDraft(communityId);
    }
  }

  void _textChanged() {
    _draftService.setPostDraft(text, communityId);
  }

  void clearDraft() {
    _draftService.removePostDraft(communityId);
  }
}
