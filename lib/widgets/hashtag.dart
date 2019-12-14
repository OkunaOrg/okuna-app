import 'package:Okuna/models/hashtag.dart';
import 'package:Okuna/provider.dart';
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
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    Color hashtagTextColor = utilsService.parseHexColor(hashtag.textColor);

    TextStyle finalTextStyle = textStyle ?? TextStyle();

    finalTextStyle = finalTextStyle
        .merge(TextStyle(color: hashtagTextColor, fontWeight: FontWeight.bold));

    Widget hashtagContent = Text(
      '#' + (rawHashtagName ?? hashtag.name),
      style: finalTextStyle,
    );

    if (hashtag.hasEmoji()) {
      hashtagContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Image(
                height: 15,
                image: AdvancedNetworkImage(hashtag.emoji.image,
                    useDiskCache: true),
              )),
          hashtagContent
        ],
      );
    }

    return GestureDetector(
      onTap: onPressed != null ? () => onPressed(hashtag) : null,
      child: hashtagContent
    );
  }
}
