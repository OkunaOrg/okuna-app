import 'package:Okuna/models/hashtag.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class OBHashtag extends StatelessWidget {
  final Hashtag hashtag;
  final ValueChanged<Hashtag> onPressed;
  final TextStyle textStyle;
  final String rawHashtagName;

  const OBHashtag(
      {Key key,
      @required this.hashtag,
      this.onPressed,
      this.textStyle,
      this.rawHashtagName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle finalTextStyle = TextStyle(fontWeight: FontWeight.bold);

    if(textStyle != null) finalTextStyle = finalTextStyle.merge(textStyle);

    Widget hashtagContent = Text(
      '#' + (rawHashtagName ?? hashtag.name),
      style: finalTextStyle,
    );

    if (hashtag.hasEmoji()) {
      hashtagContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          hashtagContent,
          Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Image(
                height: 15,
                image: AdvancedNetworkImage(hashtag.emoji.image,
                    useDiskCache: true),
              )),
        ],
      );
    }

    return GestureDetector(
      onTap: onPressed != null ? () => onPressed(hashtag) : null,
      child: hashtagContent
    );
  }
}
