import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/collapsible_smart_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OBPostBodyText extends StatefulWidget {
  final Post _post;
  final OnTextExpandedChange onTextExpandedChange;

  OBPostBodyText(this._post, {this.onTextExpandedChange}) : super();

  @override
  OBPostBodyTextState createState() {
    return OBPostBodyTextState();
  }
}

class OBPostBodyTextState extends State<OBPostBodyText> {
  static const int MAX_LENGTH_LIMIT = 1300;

  ToastService _toastService;
  BuildContext _context;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _toastService = OpenbookProvider.of(context).toastService;
    _context = context;

    return GestureDetector(
      onLongPress: _copyText,
      child: Padding(padding: EdgeInsets.only(top: 20.0, left:20, right: 20), child: _buildPostText()),
    );
  }

  Widget _buildPostText() {
    return StreamBuilder(
        stream: widget._post.updateSubject,
        initialData: widget._post,
        builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
          return _buildActionablePostText();
        });
  }

  Widget _buildActionablePostText() {
    if (widget._post.isEdited != null && widget._post.isEdited) {
      return OBCollapsibleSmartText(
        text: widget._post.text,
        trailingSmartTextElement: SecondaryTextElement(' (edited)'),
        maxlength: MAX_LENGTH_LIMIT,
      );
    } else {
      return OBCollapsibleSmartText(
        text: widget._post.text,
        maxlength: MAX_LENGTH_LIMIT,
      );
    }
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget._post.text));
    _toastService.toast(
        message: 'Text copied!', context: _context, type: ToastType.info);
  }
}

typedef void OnTextExpandedChange(
    {@required Post post, @required bool isExpanded});
