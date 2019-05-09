import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/scroll_container.dart';
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
  ScrollView _scroll;
  bool _expanded;

  double _heightCollapsed;
  double _heightExpanded;
  double _minScrollOffset;
  double _maxScrollOffset;
  bool _doScroll = false;

  @override
  void initState() {
    super.initState();
    //Must default to false, otherwise the scrolling on collapse won't work properly for the first collapse.
    _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    _toastService = OpenbookProvider.of(context).toastService;
    _context = context;
    var scrollContainer = (_context.inheritFromWidgetOfExactType(OBScrollContainer) as OBScrollContainer);
    if (scrollContainer != null)
      _scroll = scrollContainer.scroll;

    return GestureDetector(
      onLongPress: _copyText,
      child: Padding(padding: EdgeInsets.all(20.0), child: _buildPostText()),
    );
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
    if (!_expanded) {
      _heightCollapsed = context.size.height;
      if (_hasScrollController()) {
        _minScrollOffset = _scroll.controller.position.minScrollExtent;
        _maxScrollOffset = _scroll.controller.position.maxScrollExtent;
      }
    } else {
      _heightExpanded = context.size.height;
    }

    setState(() {
      _doScroll = _expanded;
      _expanded = !_expanded;

      if (_doScroll && _hasScrollController()) {
        var scrollOffset = _scroll.controller.offset - (_heightExpanded - _heightCollapsed);
        _scroll.controller.jumpTo(scrollOffset.clamp(_minScrollOffset, _maxScrollOffset));
        _doScroll = false;
      }
    });
  }

  bool _hasScrollController() {
    return _scroll != null && _scroll.controller != null;
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget._post.text));
    _toastService.toast(
        message: 'Text copied!', context: _context, type: ToastType.info);
  }
}
