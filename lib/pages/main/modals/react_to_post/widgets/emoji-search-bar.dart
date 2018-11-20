import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';

class OBEmojiSearchBar extends StatefulWidget {
  OBEmojiSearchBar({Key key}) : super(key: key);

  @override
  OBEmojiSearchBarState createState() {
    return OBEmojiSearchBarState();
  }
}

class OBEmojiSearchBarState extends State<OBEmojiSearchBar> {
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);

    EdgeInsetsGeometry inputContentPadding =
        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20);

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
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 14.0, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Search reaction...',
                  contentPadding: inputContentPadding,
                  border: InputBorder.none,
                ),
                autocorrect: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
