import 'package:Openbook/models/category.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryBadge extends StatelessWidget {
  final Category category;

  const CategoryBadge({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeValueParserService themeValueParserService =
        OpenbookProvider.of(context).themeValueParserService;
    Color badgeColor = themeValueParserService.parseColor(category.color);
    final bool badgeIsDark = badgeColor.computeLuminance() < 0.25;

    return Container(
      decoration: BoxDecoration(
          color: badgeColor, borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Text(
        category.name,
        style: TextStyle(color: badgeIsDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
