import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OBPostBodyText extends StatefulWidget {
  final Post _post;

  OBPostBodyText(this._post) : super();

  @override
  OBPostBodyTextState createState() {
    return OBPostBodyTextState();
  }
}

class OBPostBodyTextState extends State<OBPostBodyText> {
  static const int _LENGTH_LIMIT = 500;
  static const int _CUTOFF_OFFSET = 25;

  ToastService _toastService;
  BuildContext _context;
  bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    _toastService = OpenbookProvider.of(context).toastService;
    _context = context;

    return GestureDetector(
        onLongPress: _copyText,
        child: Padding(padding: EdgeInsets.all(20.0), child: _buildPostText()));
  }

  Widget _buildPostText() {
    return StreamBuilder(
        stream: widget._post.updateSubject,
        initialData: widget._post,
        builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
          Post post = snapshot.data;
          String postText = post.text;
          bool isLongPost = postText.length > _LENGTH_LIMIT;

          if (isLongPost) {
            return _buildCollapsiblePostText(postText, post, _expanded);
          } else {
            return _buildActionablePostText(postText, post);
          }
        });
  }

  Widget _buildCollapsiblePostText(String postText, Post post, bool expanded) {
    if (!_expanded) {
      var newLength = _LENGTH_LIMIT - _CUTOFF_OFFSET;
      postText = postText.substring(0, newLength).trimRight() + '...';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildActionablePostText(postText, post),
        GestureDetector(
          onTap: _toggleExpanded,
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: OBText(
              expanded ? "Show less" : "Show more",
              style: TextStyle(decoration: TextDecoration.underline),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionablePostText(String postText, Post post) {
    if (post.isEdited != null && post.isEdited) {
      return OBActionableSmartText(
        text: postText,
        trailingSmartTextElement: SecondaryTextElement(' (edited)'),
      );
    } else {
      return OBActionableSmartText(
        text: postText,
      );
    }
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget._post.text));
    _toastService.toast(message: 'Text copied!', context: _context, type: ToastType.info);
  }
}
