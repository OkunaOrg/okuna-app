import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

class OBCommunitiesTab extends StatelessWidget {
  static const double borderRadius = 10;

  final Color color;
  final Color textColor;
  final String text;
  final String backgroundImageUrl;

  const OBCommunitiesTab(
      {Key key,
      @required this.color,
      @required this.textColor,
      @required this.text,
      @required this.backgroundImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            image: DecorationImage(
              fit: BoxFit.cover,
                image: AdvancedNetworkImage(backgroundImageUrl,
                    useDiskCache: true))),
        height: 80,
        width: 130,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(borderRadius)),
              child: Text(
                text,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ),
        ));
  }
}
