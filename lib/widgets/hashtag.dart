import 'package:Okuna/models/hashtag.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class OBHashtag extends StatelessWidget {
  final Hashtag hashtag;
  final ValueChanged<Hashtag> onPressed;
  final TextStyle textStyle;

  const OBHashtag(
      {Key key,
      @required this.hashtag,
      this.onPressed,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    Color hashtagBackgroundColor = utilsService.parseHexColor(hashtag.color);
    Color hashtagTextColor = Colors.white;


    TextStyle finalTextStyle = textStyle ?? TextStyle();

    finalTextStyle = finalTextStyle.merge(TextStyle(color: hashtagTextColor, fontWeight: FontWeight.bold));

    Widget hashtagContent = Text('${hashtag.name}', style: finalTextStyle,);



    if(hashtag.hasEmoji()){
      hashtagContent  = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Image(
              height: 15,
              image: AdvancedNetworkImage(hashtag.emoji.image, useDiskCache: true),
            )
          ),
          hashtagContent
        ],
      );
    }

    return GestureDetector(
      onTap: onPressed != null ? () => onPressed(hashtag) : null,
      child: Container(
        decoration: BoxDecoration(
          color: hashtagBackgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2.5),
        child: hashtagContent,
      ),
    );
  }
}
