import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/collapsible_smart_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OBPostCommentText extends StatelessWidget {
  final PostComment postComment;
  final VoidCallback onUsernamePressed;
  final Widget badge;
  ToastService _toastService;
  BuildContext _context;

  static int postCommentMaxVisibleLength = 500;

  OBPostCommentText(this.postComment,
      {Key key, this.onUsernamePressed, this.badge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);

    _toastService = openbookProvider.toastService;
    _context = context;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onLongPress: _copyText,
                child: _getActionableSmartText(postComment.isEdited),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _getActionableSmartText(bool isEdited) {
    if (isEdited) {
      return OBCollapsibleSmartText(
        size: OBTextSize.medium,
        text: postComment.text,
        trailingSmartTextElement: SecondaryTextElement(' (edited)'),
        maxlength: postCommentMaxVisibleLength,
      );
    } else {
      return OBCollapsibleSmartText(
        size: OBTextSize.medium,
        text: postComment.text,
        maxlength: postCommentMaxVisibleLength,
      );
    }
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: postComment.text));
    _toastService.toast(
        message: 'Text copied!', context: _context, type: ToastType.info);
  }
}
