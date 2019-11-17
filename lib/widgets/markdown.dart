import 'package:Okuna/models/theme.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/theme_value_parser.dart';
import 'package:Okuna/services/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class OBMarkdown extends StatelessWidget {
  static final double pFontSize = 16;

  final String data;
  final OBTheme theme;
  final bool onlyBody;
  final bool linksRequireConfirmation;

  const OBMarkdown(
      {Key key,
      @required this.data,
      this.theme,
      this.onlyBody = false,
      this.linksRequireConfirmation = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeValueParserService = openbookProvider.themeValueParserService;
    var urlLauncherService = openbookProvider.urlLauncherService;

    if (theme != null)
      return _buildWithTheme(theme,
          context: context,
          themeValueParserService: themeValueParserService,
          urlLauncherService: urlLauncherService);

    var themeService = openbookProvider.themeService;

    return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var currentTheme = snapshot.data;
        return _buildWithTheme(currentTheme,
            context: context,
            themeValueParserService: themeValueParserService,
            urlLauncherService: urlLauncherService);
      },
    );
  }

  Widget _buildWithTheme(OBTheme theme,
      {@required ThemeValueParserService themeValueParserService,
      @required UrlLauncherService urlLauncherService,
      @required BuildContext context}) {
    var primaryColor = themeValueParserService.parseColor(theme.primaryColor);
    final bool isDarkPrimaryColor = primaryColor.computeLuminance() < 0.179;
    Color primaryTextColor =
        themeValueParserService.parseColor(theme.primaryTextColor);
    Color accentColor = isDarkPrimaryColor
        ? Color.fromARGB(10, 0, 0, 0)
        : Color.fromARGB(20, 255, 255, 255);
    Color actionsForegroundColor = themeValueParserService
        .parseGradient(theme.primaryAccentColor)
        .colors[1];

    ThemeData flutterTheme = Theme.of(context);

    MarkdownStyleSheet styleSheet = MarkdownStyleSheet.fromTheme(flutterTheme)
        .copyWith(
            code: new TextStyle(
                color: primaryTextColor,
                fontFamily: "monospace",
                fontSize: flutterTheme.textTheme.body1.fontSize * 0.85),
            h1: flutterTheme.textTheme.headline
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h2: flutterTheme.textTheme.title
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h3: flutterTheme.textTheme.subhead
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h4: flutterTheme.textTheme.body2
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h5: flutterTheme.textTheme.body2
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h6: flutterTheme.textTheme.body2
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            em: const TextStyle(fontStyle: FontStyle.italic),
            strong: const TextStyle(fontWeight: FontWeight.bold),
            img: flutterTheme.textTheme.body1.copyWith(color: primaryTextColor),
            codeblockDecoration: new BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: new BorderRadius.circular(2.0)),
            horizontalRuleDecoration: new BoxDecoration(
              border: new Border(
                  top: new BorderSide(width: 2.0, color: accentColor)),
            ),
            blockSpacing: 10.0,
            listIndent: 32.0,
            blockquotePadding: 10.0,
            p: flutterTheme.textTheme.body1
                .copyWith(color: primaryTextColor, fontSize: pFontSize),
            a: TextStyle(color: actionsForegroundColor, fontSize: pFontSize),
            blockquoteDecoration: BoxDecoration(
                color: accentColor,
                borderRadius: new BorderRadius.circular(5.0)));

    Function onTapLink = (String tappedLink) async {
      bool canLaunchUrl = await urlLauncherService.canLaunchUrl(tappedLink);
      if (canLaunchUrl) {
        if (linksRequireConfirmation) {
          urlLauncherService.launchUrlWithConfirmation(tappedLink, context);
        } else {
          urlLauncherService.launchUrlWithoutConfirmation(tappedLink);
        }
      }
    };

    return onlyBody
        ? MarkdownBody(
            data: data,
            styleSheet: styleSheet,
            onTapLink: onTapLink,
          )
        : Markdown(
            data: data,
            styleSheet: styleSheet,
            onTapLink: onTapLink,
          );
  }
}
