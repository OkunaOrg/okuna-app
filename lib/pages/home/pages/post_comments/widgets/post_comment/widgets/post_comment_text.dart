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

  static int postCommentMaxVisibleLength = 500;

  OBPostCommentText(this.postComment, {Key key, this.onUsernamePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onLongPress: () {
                  OpenbookProviderState openbookProvider =
                      OpenbookProvider.of(context);
                  Clipboard.setData(ClipboardData(text: postComment.text));
                  openbookProvider.toastService.toast(
                      message: 'Text copied!',
                      context: context,
                      type: ToastType.info);
                },
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
        size: OBTextSize.large,
        text: postComment.text,
        trailingSmartTextElement: SecondaryTextElement(' (edited)'),
        maxlength: postCommentMaxVisibleLength,
      );
    } else {
      return OBCollapsibleSmartText(
        size: OBTextSize.large,
        text: postComment.text,
        maxlength: postCommentMaxVisibleLength,
      );
    }
  }
}
