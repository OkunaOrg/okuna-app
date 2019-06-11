import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expandable/expandable.dart';

class OBPostBodyText extends StatefulWidget {
  final Post _post;
  final ValueChanged<bool> onTextExpandedChange;

  OBPostBodyText(this._post, {this.onTextExpandedChange}) : super();

  @override
  OBPostBodyTextState createState() {
    return OBPostBodyTextState();
  }
}

class OBPostBodyTextState extends State<OBPostBodyText> {
  static const int _LENGTH_LIMIT = 200;

  ToastService _toastService;
  BuildContext _context;

  ExpandableController _expandableController;

  @override
  void initState() {
    super.initState();
    _expandableController = ExpandableController(false);
    if (widget.onTextExpandedChange != null)
      _expandableController.addListener(_onExpandableControllerChange);
  }

  void _onExpandableControllerChange() {
    if (widget.onTextExpandedChange != null)
      widget.onTextExpandedChange(_expandableController.value);
  }

  @override
  Widget build(BuildContext context) {
    _toastService = OpenbookProvider.of(context).toastService;
    _context = context;

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

          return isLongPost
              ? _buildExpandableWidget()
              : _buildActionablePostText();
        });
  }

  Widget _buildExpandableWidget() {
    return ExpandableNotifier(
      controller: _expandableController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: _buildActionablePostText(maxlength: _LENGTH_LIMIT),
            expanded: _buildActionablePostText(),
          ),
          Builder(builder: (BuildContext context) {
            var exp = ExpandableController.of(context);

            return GestureDetector(
                onTap: () {
                  exp.toggle();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      OBSecondaryText(
                        exp.expanded ? "Show less" : "Show more",
                        size: OBTextSize.medium,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OBIcon(
                        exp.expanded ? OBIcons.arrowUp : OBIcons.arrowDown,
                        themeColor: OBIconThemeColor.secondaryText,
                      )
                    ],
                  ),
                ));
          })
        ],
      ),
    );
  }

  Widget _buildActionablePostText({int maxlength}) {
    if (widget._post.isEdited != null && widget._post.isEdited) {
      return OBActionableSmartText(
        text: widget._post.text,
        trailingSmartTextElement: SecondaryTextElement(' (edited)'),
        maxlength: maxlength,
      );
    } else {
      return OBActionableSmartText(
        text: widget._post.text,
        maxlength: maxlength,
      );
    }
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget._post.text));
    _toastService.toast(
        message: 'Text copied!', context: _context, type: ToastType.info);
  }
}
