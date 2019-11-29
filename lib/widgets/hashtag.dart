import 'package:Okuna/models/hashtag.dart';
import 'package:Okuna/provider.dart';
import 'package:flutter/material.dart';

class OBHashtag extends StatelessWidget {
  final Hashtag hashtag;
  final ValueChanged<Hashtag> onPressed;
  final TextStyle textStyle;

  const OBHashtag(
      {Key key,
      @required this.hashtag,
      this.onPressed,
      @required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    Color hashtagBackgroundColor = utilsService.parseHexColor(hashtag.color);
    Color hashtagTextColor = Colors.white;


    TextStyle finalTextStyle = textStyle ?? TextStyle();

    finalTextStyle = finalTextStyle.merge(TextStyle(color: hashtagTextColor));

    return GestureDetector(
      onTap: onPressed != null ? () => onPressed(hashtag) : null,
      child: Container(
        decoration: BoxDecoration(
          color: hashtagBackgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text('${hashtag.name}', style: finalTextStyle,),
      ),
    );
  }
}
