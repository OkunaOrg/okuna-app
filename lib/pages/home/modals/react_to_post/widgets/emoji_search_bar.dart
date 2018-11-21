import 'package:flutter/material.dart';

class OBEmojiSearchBar extends StatefulWidget {
  OBEmojiSearchBarOnSearch onSearch;

  OBEmojiSearchBar({Key key, @required this.onSearch}) : super(key: key);

  @override
  OBEmojiSearchBarState createState() {
    return OBEmojiSearchBarState();
  }
}

class OBEmojiSearchBarState extends State<OBEmojiSearchBar> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() {
      widget.onSearch(_textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasClearButton = _textController.text.length > 0;

    EdgeInsetsGeometry inputContentPadding = EdgeInsets.only(
        top: 8.0, bottom: 8.0, left: 20, right: hasClearButton ? 40 : 20);

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
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0, right: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromARGB(10, 0, 0, 0),
              ),
              child: Stack(
                children: <Widget>[
                  TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    decoration: InputDecoration(
                        hintText: 'Search reaction...',
                        contentPadding: inputContentPadding,
                        border: InputBorder.none),
                    autocorrect: true,
                  ),
                  hasClearButton
                      ? Positioned(
                          right: 0,
                          child: _buildClearButton(),
                        )
                      : SizedBox()
                ],
              ),
            ),
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
    setState(() {
      _textController.clear();
    });
  }
}

typedef void OBEmojiSearchBarOnSearch(String searchString);
