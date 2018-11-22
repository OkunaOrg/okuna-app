import 'package:flutter/material.dart';

class OBEmojiSearchBar extends StatefulWidget {
  OBEmojiSearchBarOnSearch onSearch;
  VoidCallback onCancel;

  OBEmojiSearchBar({Key key, @required this.onSearch}) : super(key: key);

  @override
  OBEmojiSearchBarState createState() {
    return OBEmojiSearchBarState();
  }
}

class OBEmojiSearchBarState extends State<OBEmojiSearchBar> {
  TextEditingController _textController;
  FocusNode _textFocusNode;

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    _textController = TextEditingController();
    _textController.addListener(() {
      widget.onSearch(_textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasText = _textController.text.length > 0;

    EdgeInsetsGeometry inputContentPadding = EdgeInsets.only(
        top: 8.0, bottom: 8.0, left: 20, right: hasText ? 40 : 20);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromARGB(10, 0, 0, 0)))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20.0,
          ),
          Icon(Icons.search),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromARGB(10, 0, 0, 0),
              ),
              child: Stack(
                children: <Widget>[
                  TextField(
                    focusNode: _textFocusNode,
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    decoration: InputDecoration(
                        hintText: 'Search reaction...',
                        contentPadding: inputContentPadding,
                        border: InputBorder.none),
                    autocorrect: true,
                  ),
                  hasText
                      ? Positioned(
                          right: 0,
                          child: _buildClearButton(),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
          hasText
              ? FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Text('Cancel'),
                  onPressed: _cancelSearch,
                )
              : SizedBox(
                  width: 20.0,
                )
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      child: Container(
        height: 35.0,
        width: 35.0,
        child: Icon(
          Icons.clear,
          size: 15.0,
        ),
      ),
      onTap: _clearText,
    );
  }

  void _clearText() {
    _textController.clear();
  }

  void _cancelSearch() {
    // Unfocus text
    FocusScope.of(context).requestFocus(new FocusNode());
    _textController.clear();
    if (widget.onCancel != null) widget.onCancel();
  }
}

typedef void OBEmojiSearchBarOnSearch(String searchString);
