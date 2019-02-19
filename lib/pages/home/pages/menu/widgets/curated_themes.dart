import 'package:Openbook/models/theme.dart';
import 'package:Openbook/pages/home/pages/menu/widgets/widgets/theme_preview.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCuratedThemes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var themeService = OpenbookProvider.of(context).themeService;
    var themes = themeService.getCuratedThemes();

    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: const OBText(
              'Curated themes',
              style: TextStyle(fontWeight: FontWeight.bold),
              size: OBTextSize.large,
            ),
          ),
          SizedBox(
            height: 70,
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: themes.length,
              itemBuilder: (BuildContext context, int index) {
                return OBThemePreview(
                  themes[index],
                  onThemePreviewPressed: (OBTheme theme) {
                    themeService.setActiveTheme(theme);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 20,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
